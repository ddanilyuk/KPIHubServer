import Vapor
import Routes
import RozkladParser

extension Lesson: Content {

}

extension Teacher: Content {

}

func routes(_ app: Application) throws {
    app.get { req in
        return "\(APIRoute.first)"
    }

    app.get("hello") { req -> [Lesson] in
        var string = "Hello, world!"
        return try RozkladParser().parse(&string)
    }
}
