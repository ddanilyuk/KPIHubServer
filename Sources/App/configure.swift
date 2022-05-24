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
//    app.e
    app.logger.notice("env \(app.environment)")
    app.logger.notice("host \(Environment.get("DATABASE_HOST") ?? "no value")")
    app.logger.notice("port \(Environment.get("DATABASE_PORT") ?? "no value")")
    app.logger.notice("username \(Environment.get("DATABASE_USERNAME") ?? "no value")")
    app.logger.notice("password \(Environment.get("DATABASE_PASSWORD") ?? "no value")")
    app.logger.notice("name \(Environment.get("DATABASE_NAME") ?? "no value")")

    app.databases.use(
        .postgres(
            hostname: Environment.get("DATABASE_HOST")!,
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME")!,
            password: Environment.get("DATABASE_PASSWORD")!,
            database: Environment.get("DATABASE_NAME")!
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
        let groups = try await groupsController.getNewGroups(
            client: application.client,
            logger: application.logger
        )
        try await GroupModel.query(on: application.db).delete(force: true)
        try await groups.create(on: application.db)
        application.logger.info("\(Self.self) Successfully finished")
    }
}
