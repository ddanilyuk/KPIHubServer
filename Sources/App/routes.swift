import Vapor
import Routes

func routes(_ app: Application) throws {
    app.get { req in
        return "\(APIRoute.first)"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
