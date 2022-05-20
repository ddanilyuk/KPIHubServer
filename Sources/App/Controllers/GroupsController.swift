//
//  GroupsController.swift
//  
//
//  Created by Denys Danyliuk on 20.05.2022.
//

import Vapor
import RozkladParser

final class GroupsController {

    func parseAllGroups(request: Request) async throws -> GroupsResponse {

        let ukrAlp: [String] = [
            "а",
//            "б", "в", "г", "д", "е", "є", "ж", "з", "и", "і",
//            "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т",
//            "у", "ф", "ч", "ц", "ч", "ш", "щ", "ю", "я", "ь"
        ]

        let groups = try await ukrAlp
            .asyncMap { alp -> AllGroupsResponse in
                let response: ClientResponse = try await request.client.post(
                    "http://rozklad.kpi.ua/Schedules/ScheduleGroupSelection.aspx/GetGroups",
                    beforeSend: { clientRequest in
                        let content = AllGroupQuery(prefixText: alp, count: 100)
                        try clientRequest.content.encode(content)
                    }
                )
                return try response.content.decode(AllGroupsResponse.self)
            }
            .reduce(into: []) { partialResult, response in
                partialResult.append(contentsOf: response.d ?? [])
            }
            .asyncMap { groupName -> [Group] in
//                try await request.client.
                let response: ClientResponse = try await request.client.post(
                    "http://rozklad.kpi.ua/Schedules/ScheduleGroupSelection.aspx",
                    beforeSend: { clientRequest in
                        clientRequest.headers.add(
                            name: .contentType,
                            value: "application/x-www-form-urlencoded"
                        )
                        let parameters = "ctl00_ToolkitScriptManager_HiddenField=&__VIEWSTATE=%2FwEMDAwQAgAADgEMBQAMEAIAAA4BDAUDDBACAAAOAgwFBwwQAgwPAgEIQ3NzQ2xhc3MBD2J0biBidG4tcHJpbWFyeQEEXyFTQgUCAAAADAUNDBACAAAOAQwFAQwQAgAADgEMBQ0MEAIMDwEBBFRleHQBG9Cg0L7Qt9C60LvQsNC0INC30LDQvdGP0YLRjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALVdjzppTCyUtNVSyV7xykGQzHz2&__EVENTTARGET=&__EVENTARGUMENT=&ctl00%24MainContent%24ctl00%24txtboxGroup=\(groupName)&ctl00%24MainContent%24ctl00%24btnShowSchedule=%D0%A0%D0%BE%D0%B7%D0%BA%D0%BB%D0%B0%D0%B4%2B%D0%B7%D0%B0%D0%BD%D1%8F%D1%82%D1%8C&__EVENTVALIDATION=%2FwEdAAEAAAD%2F%2F%2F%2F%2FAQAAAAAAAAAPAQAAAAUAAAAIsA3rWl3AM%2B6E94I5Tu9cRJoVjv0LAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHfLZVQO6kVoZVPGurJN4JJIAuaU&hiddenInputToUpdateATBuffer_CommonToolkitScripts=0"
                        if let postData = parameters.data(using: .utf8) {
                            clientRequest.body = ByteBuffer(data: postData)
                        }
                    }
                )
                request.logger.info("\(response)")
                guard
                    var body = response.body,
                    let html = body.readString(length: body.readableBytes)
                else {
                    throw Abort(.internalServerError)
                }
                let parsed = try GroupIdParser(groupName: groupName).parse(html)

                return parsed.map { Group(id: $0.groupId, name: $0.groupName) }
//                try response.content.decode(AllGroupsResponse.self)
            }
            .flatMap { $0 }

        return GroupsResponse(numberOfGroups: groups.count, groups: groups)
    }
}
