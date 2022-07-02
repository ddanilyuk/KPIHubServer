//
//  RozkladController.swift
//  
//
//  Created by Denys Danyliuk on 20.05.2022.
//

import Vapor
import KPIHubParser
import Fluent
import FluentPostgresDriver
import Foundation
import Routes

/// This client is base on parsing groups and lessons from rozklad.kpi.ua
final class RozkladController {

    static let ukrainianAlphabet: [String] = [
        "а", "б", "в", "г", "д", "е", "є", "ж", "з", "и", "і",
        "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т",
        "у", "ф", "ч", "ц", "ч", "ш", "щ", "ю", "я", "ь"
    ]

    // MARK: - Requests

    func allGroups(request: Request) async throws -> GroupsResponse {
        let groupModels = try await GroupModel.query(on: request.db).all()
        return GroupsResponse(numberOfGroups: groupModels.count, groups: groupModels)
    }

    func search(request: Request, searchQuery: GroupSearchQuery) async throws -> GroupModel {
        // TODO: Handle multiple groups with one name
        let groupModel = try await GroupModel.query(on: request.db)
            .filter(\.$name == searchQuery.groupName)
            .first()
        if let groupModel = groupModel {
            return groupModel
        } else {
            throw Abort(.notFound, reason: "Group not found")
        }
    }

    func forceRefresh(request: Request) async throws -> GroupsResponse {
        let groups = try await getNewGroups(
            client: request.client,
            logger: request.logger
        )
        try await GroupModel.query(on: request.db).delete(force: true)
        try await groups.create(on: request.db)
        let groupModels = try await GroupModel.query(on: request.db).all()
        return GroupsResponse(
            numberOfGroups: groupModels.count,
            groups: groupModels
        )
    }

    // MARK: - Other methods

    func getNewGroups(client: Client, logger: Logger) async throws -> [GroupModel] {
        var numberOfParsedGroups = 0

        // Receiving groups names from first endpoint
        let groupsNames = try await RozkladController.ukrainianAlphabet
            .asyncMap { letter -> AllGroupsClientResponse in
                let response: ClientResponse = try await client.post(
                    "http://rozklad.kpi.ua/Schedules/ScheduleGroupSelection.aspx/GetGroups",
                    beforeSend: { clientRequest in
                        let content = AllGroupClientRequest(prefixText: letter, count: 100)
                        try clientRequest.content.encode(content)
                    }
                )
                return try response.content.decode(AllGroupsClientResponse.self)
            }
            .reduce(into: []) { partialResult, response in
                partialResult.append(contentsOf: response.d ?? [])
            }

        // Receiving groups id from second endpoint and parsing it
        return try await groupsNames
            .asyncMap { groupName -> [GroupModel] in
                let response: ClientResponse = try await client.post(
                    "http://rozklad.kpi.ua/Schedules/ScheduleGroupSelection.aspx",
                    beforeSend: { clientRequest in
                        clientRequest.headers.add(
                            name: .contentType,
                            value: "application/x-www-form-urlencoded"
                        )
                        let parameters = scheduleGroupSelectionParameters(with: groupName)
                        if let postData = parameters.data(using: .utf8) {
                            clientRequest.body = ByteBuffer(data: postData)
                        }
                    }
                )
                numberOfParsedGroups += 1
                logger.info("\(numberOfParsedGroups) \(response.headers)")
                let html = try (response.body).htmlString(encoding: .utf8)
                return try GroupParser(groupName: groupName)
                    .parse(html)
                    .map { GroupModel(id: $0.id, name: $0.name) }
            }
            .flatMap { $0 }
            .uniqued()
    }

    func getLessons(for groupUUID: UUID, request: Request) async throws -> LessonsResponse {
        let response = try await request.client.get(
            "http://rozklad.kpi.ua/Schedules/ViewSchedule.aspx?g=\(groupUUID.uuidString)"
        )
        let html = try (response.body).htmlString(encoding: .utf8)
        let lessons = try LessonsParser().parse(html)
        return LessonsResponse(id: groupUUID, lessons: lessons)
    }

    func scheduleGroupSelectionParameters(with groupName: String) -> String {
        "ctl00_ToolkitScriptManager_HiddenField=&__VIEWSTATE=%2FwEMDAwQAgAADgEMBQAMEAIAAA4BDAUDDBACAAAOAgwFBwwQAgwPAgEIQ3NzQ2xhc3MBD2J0biBidG4tcHJpbWFyeQEEXyFTQgUCAAAADAUNDBACAAAOAQwFAQwQAgAADgEMBQ0MEAIMDwEBBFRleHQBG9Cg0L7Qt9C60LvQsNC0INC30LDQvdGP0YLRjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALVdjzppTCyUtNVSyV7xykGQzHz2&__EVENTTARGET=&__EVENTARGUMENT=&ctl00%24MainContent%24ctl00%24txtboxGroup=\(groupName)&ctl00%24MainContent%24ctl00%24btnShowSchedule=%D0%A0%D0%BE%D0%B7%D0%BA%D0%BB%D0%B0%D0%B4%2B%D0%B7%D0%B0%D0%BD%D1%8F%D1%82%D1%8C&__EVENTVALIDATION=%2FwEdAAEAAAD%2F%2F%2F%2F%2FAQAAAAAAAAAPAQAAAAUAAAAIsA3rWl3AM%2B6E94I5Tu9cRJoVjv0LAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHfLZVQO6kVoZVPGurJN4JJIAuaU&hiddenInputToUpdateATBuffer_CommonToolkitScripts=0"
    }

}
