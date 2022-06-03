import Vapor
import Routes
import KPIHubParser

// MARK: - rootHandler

func rootHandler(
    request: Request,
    route: RootRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .home:
        return "\(route)"

    case let .api(route):
        return try await apiHandler(request: request, route: route)
    }
}

// MARK: - apiHandler

func apiHandler(
    request: Request,
    route: APIRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case let .campus(route):
        return try await campusHandler(request: request, route: route)


    case let .groups(route):
        return try await groupsHandler(request: request, route: route)

    case let .group(uuid, route):
        return try await groupHandler(uuid: uuid, request: request, route: route)
    }
}

// MARK: - campusHandler

func campusHandler(
    request: Request,
    route: CampusRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case let .userInfo(loginQuery):
        let controller = CampusController()
        return try await controller.userInfo(request: request, loginQuery: loginQuery)

    case .currentСontrol:
        let controller = CampusController()
        return try await controller.getCurrent(request: request)
    }
}

// MARK: - groupsHandler

func groupsHandler(
    request: Request,
    route: GroupsRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .all:
        let controller = GroupsController()
        return try await controller.allGroups(request: request)

    case .forceRefresh:
        let controller = GroupsController()
        return try await controller.forceRefresh(request: request)

    case let .search(groupQuery):
        return "\(route) | \(groupQuery)"
    }
}

// MARK: - groupHandler

func groupHandler(
    uuid: UUID,
    request: Request,
    route: GroupRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .lessons:
        let controller = LessonsController()
        return try await controller.getGroups(for: uuid, request: request)
    }
}
