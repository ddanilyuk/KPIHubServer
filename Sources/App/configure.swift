import Vapor
import VaporRouting
import Routes
import Fluent
import FluentPostgresDriver
import VaporCron


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
            username: "vapor",
            password: "vapor123",
            database: "vapor"
        ),
        as: .psql
    )
    app.migrations.add(GroupModel())
    
    app.mount(router, use: siteHandler)

    try app.cron.schedule(RefreshGroupsCron.self)
}


public struct RefreshGroupsCron: AsyncVaporCronSchedulable {
    public typealias T = Void

    public static var expression: String {
        "0 4 * * *"
    }

    public static func task(on application: Application) async throws -> Void {
        application.logger.info("\(Self.self) is running...")
        let groupsController = GroupsController()
        let groups = try await groupsController.getNewGroups(client: application.client)
        try await GroupModel.query(on: application.db).delete(force: true)
        try await groups.create(on: application.db)
        application.logger.info("\(Self.self) Successfully finished")
    }
}
