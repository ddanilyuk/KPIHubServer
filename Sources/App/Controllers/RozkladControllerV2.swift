//
//  GroupsControllerV2.swift
//  
//
//  Created by Denys Danyliuk on 01.07.2022.
//

import Vapor
import Routes
import KPIHubParser
import Foundation

final class RozkladControllerV2 {

    func allGroups(request: Request) async throws -> GroupsResponseV2 {
        let response: ClientResponse = try await request.client.get(
            "https://schedule.kpi.ua/api/schedule/groups"
        )
        let result = try response.content.decode(GroupModelV2ClientResponse.self)
        return GroupsResponseV2(
            numberOfGroups: result.data.count,
            groups: result.data.sorted(by: {
                $0.name.compare($1.name, locale: Locale(identifier: "uk")) == .orderedAscending
            })
        )
    }

    func search(request: Request, searchQuery: GroupSearchQuery) async throws -> GroupV2 {
        let allGroups = try await allGroups(request: request)
        let searchedGroup = allGroups.groups.first {
            $0.name.lowercased().contains(searchQuery.groupName.lowercased())
        }
        if let searchedGroup = searchedGroup {
            return searchedGroup
        } else {
            throw Abort(.notFound, reason: "Group not found")
        }
    }

    func getLessons(for groupUUID: UUID, request: Request) async throws -> LessonsResponseV2 {
        let response: ClientResponse = try await request.client.get(
            "https://schedule.kpi.ua/api/schedule/lessons",
            beforeSend: { request in
                try request.query.encode(["groupId": groupUUID.uuidString])
            }
        )
        let lessonsV2ClientResponse = try response.content.decode(LessonsV2ClientResponse.self)
        return LessonsResponseV2(id: groupUUID, lessons: lessonsV2ClientResponse.lessonsV2())
    }
    
}
