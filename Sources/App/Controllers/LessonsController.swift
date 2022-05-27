//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import KPIHubParser

final class LessonsController {

    func getGroups(for uuid: UUID, request: Request) async throws -> LessonResponse {

        let response = try await request.client.get(
            "http://rozklad.kpi.ua/Schedules/ViewSchedule.aspx?g=\(uuid.uuidString)"
        )
        guard
            var body = response.body,
            let html = body.readString(length: body.readableBytes)
        else {
            throw Abort(.internalServerError)
        }
        let lessons = try RozkladParser().parse(html)
        return LessonResponse(id: uuid, lessons: lessons)
    }
}
