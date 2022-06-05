//
//  CampusController.swift
//  
//
//  Created by Denys Danyliuk on 02.06.2022.
//

import Vapor
import KPIHubParser
import Routes

final class CampusController {

    func userInfo(
        request: Request,
        loginQuery: CampusLoginQuery
    ) async throws -> UserInfo {
        let oauthResponse = try await oauth(request: request, loginQuery: loginQuery)
        let campusAPICredentials = try oauthResponse.content.decode(CampusAPICredentials.self)

        let accountInfoResponse: ClientResponse = try await request.client.get(
            "https://api.campus.kpi.ua/Account/Info",
            beforeSend: { clientRequest in
                let auth = BearerAuthorization(token: campusAPICredentials.accessToken)
                clientRequest.headers.bearerAuthorization = auth
            }
        )
        return try accountInfoResponse.content.decode(UserInfo.self)
    }

    func studySheet(
        request: Request,
        loginQuery: CampusLoginQuery
    ) async throws -> StudySheetResponse {

        let oauthResponse = try await oauth(request: request, loginQuery: loginQuery)
        let campusAPICredentials = try oauthResponse.content.decode(CampusAPICredentials.self)

        let authPHPResponse: ClientResponse = try await request.client.get(
            "https://campus.kpi.ua/auth.php",
            beforeSend: { clientRequest in
                clientRequest.headers.cookie = oauthResponse.headers.setCookie
            }
        )

        let studySheetResponse: ClientResponse = try await request.client.get(
            "https://campus.kpi.ua/student/index.php?mode=studysheet",
            beforeSend: { clientRequest in
                let auth = BearerAuthorization(token: campusAPICredentials.accessToken)
                clientRequest.headers.bearerAuthorization = auth
                if let phpSessionId = authPHPResponse.headers.setCookie?.all["PHPSESSID"] {
                    clientRequest.headers.cookie = HTTPCookies(
                        dictionaryLiteral: ("PHPSESSID", phpSessionId)
                    )
                }
            }
        )

        let html = try (studySheetResponse.body).htmlString(encoding: .windowsCP1251)

        let studySheetItems = try await StudySheetLessonsParser().parse(html)
            .asyncMap { lesson -> StudySheetItem in
                let response: ClientResponse = try await request.client.post(
                    "https://campus.kpi.ua\(lesson.link)",
                    beforeSend: { clientRequest in
                        let auth = BearerAuthorization(token: campusAPICredentials.accessToken)
                        clientRequest.headers.bearerAuthorization = auth
                        if let phpSessionId = authPHPResponse.headers.setCookie?.all["PHPSESSID"] {
                            clientRequest.headers.cookie = HTTPCookies(
                                dictionaryLiteral: ("PHPSESSID", phpSessionId)
                            )
                        }
                    }
                )
                let html = try (response.body).htmlString(encoding: .windowsCP1251)
                let activities = try StudySheetActivitiesParser().parse(html)
                return StudySheetItem(lesson: lesson, activities: activities)
            }

        return StudySheetResponse(studySheet: studySheetItems)
    }

    // MARK: - Helpers

    func oauth(
        request: Request,
        loginQuery: CampusLoginQuery
    ) async throws -> ClientResponse {
        try await request.client.post(
            "https://api.campus.kpi.ua/oauth/token",
            beforeSend: { clientRequest in
                try clientRequest.query.encode(loginQuery)
            }
        )
    }

}
