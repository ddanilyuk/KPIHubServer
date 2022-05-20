import Vapor
import Routes
import RozkladParser

extension Lesson: Content {

}

extension Teacher: Content {

}

struct LessonResponse: Content {
    var id: UUID
    let lessons: [Lesson]
}

struct AllGroupsResponse: Content {
    var d: [String]?
}

struct GroupsResponse {
    let numberOfGroups: Int
    let groups: [GroupModel]
}
extension GroupsResponse: Content {

}

struct Group {
    let id: String
    let name: String
}
extension Group: Content {

}

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .home:
        return "\(route)"

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

public struct AllGroupQuery: Content {


    public var prefixText: String
    public var count: Int

    public init(prefixText: String, count: Int) {
        self.prefixText = prefixText
        self.count = count
    }

}

func groupsHandler(
    request: Request,
    route: GroupsRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .all:
        let controller = GroupsController()
        return try await controller.parseAllGroups(request: request)
//        let ukrAlp: [String] = [
//            "а", "б", "в", "г", "д", "е", "є", "ж", "з", "и", "і",
//            "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т",
//            "у", "ф", "ч", "ц", "ч", "ш", "щ", "ю", "я", "ь"
//        ]
//
//        let jsons: [AllGroupsResponse] = try await ukrAlp.asyncMap { alp -> AllGroupsResponse in
//            let response: ClientResponse = try await request.client.post(
//                "http://rozklad.kpi.ua/Schedules/ScheduleGroupSelection.aspx/GetGroups",
//                beforeSend: { clientRequest in
//                    let content = AllGroupQuery(prefixText: alp, count: 100)
//                    try clientRequest.content.encode(content)
//                }
//            )
//            return try response.content.decode(AllGroupsResponse.self)
//        }
//        request.logger.debug("\(jsons)")
//
//        let result = jsons.reduce(into: []) { partialResult, response in
//            partialResult.append(contentsOf: response.d ?? [])
//        }
//        return result

    case .forceRefresh:
        let controller = GroupsController()
        return try await controller.forceRefresh(request: request)

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

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
