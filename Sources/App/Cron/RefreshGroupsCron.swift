//
//  RefreshGroupsCron.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import VaporCron

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
