import Vapor
import VaporRouting
import Routes
import Fluent
import FluentPostgresDriver
import VaporCron

public func configure(_ app: Application) throws {

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    app.logger.notice("env \(app.environment)")
    app.logger.notice("host \(Environment.get("DATABASE_HOST") ?? "no value")")
    app.logger.notice("port \(Environment.get("DATABASE_PORT") ?? "no value")")
    app.logger.notice("username \(Environment.get("DATABASE_USERNAME") ?? "no value")")
    app.logger.notice("password \(Environment.get("DATABASE_PASSWORD") ?? "no value")")
    app.logger.notice("name \(Environment.get("DATABASE_NAME") ?? "no value")")

    // MARK: - Database connect

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

    // MARK: - Migrations

    app.migrations.add(GroupModel())

    // MARK: - Routing

    app.mount(rootRouter, use: rootHandler)

    // MARK: - Client configuration

    app.http.client.configuration.redirectConfiguration = .disallow

    // MARK: - Cron

    try app.cron.schedule(RefreshGroupsCron.self)
}
