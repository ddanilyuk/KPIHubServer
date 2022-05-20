import Vapor
import VaporRouting
import Routes
import Fluent
import FluentPostgresDriver

//enum SiteRouterKey: StorageKey {
//    typealias Value = AnyParserPrinter<URLRequestData, SiteRoute>
//}
//
//extension Application {
//    var router: SiteRouterKey.Value {
//        get {
//            self.storage[SiteRouterKey.self]!
//        }
//        set {
//            self.storage[SiteRouterKey.self] = newValue
//        }
//    }
//}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
//    try routes(app)
//    app.router = router
//        .baseURL("http://127.0.0.1:8080")
//        .eraseToAnyParserPrinter()

    app.databases.use(
        .postgres(
            hostname: "localhost",
//            port: 5432,
            username: "vapor",
            password: "vapor123",
            database: "vapor"
        ),
        as: .psql
    )
    app.migrations.add(GroupModel())
    
    app.mount(router, use: siteHandler)

}
