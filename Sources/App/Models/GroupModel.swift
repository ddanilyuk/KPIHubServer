//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import FluentSQL

final class GroupModel: Model {

    static let schema = "groups"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    // Creates a new, empty Galaxy.
    init() {
        name = ""
    }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }

}

// MARK: - GroupModel + AsyncMigration

extension GroupModel: AsyncMigration {

    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema(GroupModel.schema)
            .id()
            .field("name", .string)
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(GroupModel.schema).delete()
    }
    
}
