import Vapor
import Routes
import RozkladParser

extension Lesson: Content {

}

extension Teacher: Content {

}

struct LessonResponse: Content {
    var id: String
    let lessons: [Lesson]
}

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .home:
        let id = "60ed5ac1-c1a1-40d9-968d-d54ae056c1ca"
        let response = try await request.client.get(
            "http://rozklad.kpi.ua/Schedules/ViewSchedule.aspx?g=\(id)"
        )
        guard
            var body = response.body,
            let html = body.readString(length: body.readableBytes)
        else {
            throw Abort(.internalServerError)
        }
        let lessons = try RozkladParser().parse(html)
        return LessonResponse(id: id, lessons: lessons)

    case let .api(route):
        return try await apiHandler(request: request, route: route)
    }
}

func apiHandler(
    request: Request,
    route: APIRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case let .groups(route):
        return try await groupsHandler(request: request, route: route)

    case let .group(uuid, route):
        return try await groupHandler(uuid: uuid, request: request, route: route)
    }
}

func groupsHandler(
    request: Request,
    route: GroupsRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .all:
        return "\(route)"

    case let .search(groupQuery):
        return "\(route)"
    }
}

func groupHandler(
    uuid: UUID,
    request: Request,
    route: GroupRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .lessons:
        return "\(route)"
    }
}
