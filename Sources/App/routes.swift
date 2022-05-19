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

//func routes(_ app: Application) throws {
//
//    app.get { req in
//        return "\(APIRoute.first)"
//    }
//
//    app.get("test") { req async throws -> LessonResponse in
//        let response = try await req.client.get("http://rozklad.kpi.ua/Schedules/ViewSchedule.aspx?g=60ed5ac1-c1a1-40d9-968d-d54ae056c1ca")
//        guard
//            var body = response.body,
//            let html = body.readString(length: body.readableBytes)
//        else {
//            throw Abort(.internalServerError)
//        }
//        let lessons = try RozkladParser().parse(html)
//        return LessonResponse(id: "60ed5ac1-c1a1-40d9-968d-d54ae056c1ca", lessons: lessons)
//    }
//
//}

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> AsyncResponseEncodable {
    return "\(route)"
    switch route {
    case .home:
        return [String: String]()
    case let .api(route):
        return [String: String]()
//        return try await usersHandler(request: request, route: route)
    }
}
