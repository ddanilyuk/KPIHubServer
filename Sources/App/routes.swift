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

    case let .studySheet(loginQuery):
        let controller = CampusController()
        return try await controller.studySheet(request: request, loginQuery: loginQuery)
    }
}

// MARK: - groupsHandler

func groupsHandler(
    request: Request,
    route: GroupsRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .all:
        let controller = RozkladController()
        return try await controller.allGroups(request: request)

    case let .search(searchQuery):
        let controller = RozkladController()
        return try await controller.search(request: request, searchQuery: searchQuery)

    case .forceRefresh:
        let controller = RozkladController()
        return try await controller.forceRefresh(request: request)
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
        let controller = RozkladController()
        return try await controller.getLessons(for: uuid, request: request)
    }
}
