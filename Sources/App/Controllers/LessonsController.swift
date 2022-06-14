//
//  LessonsController.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import KPIHubParser

final class LessonsController {

    func getLessons(for groupUUID: UUID, request: Request) async throws -> LessonsResponse {
        let response = try await request.client.get(
            "http://rozklad.kpi.ua/Schedules/ViewSchedule.aspx?g=\(groupUUID.uuidString)"
        )
        let html = try (response.body).htmlString(encoding: .utf8)
        let lessons = try LessonsParser().parse(html)
        return LessonsResponse(id: uuid, lessons: lessons)
    }
    
}
