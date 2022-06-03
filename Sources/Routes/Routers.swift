//
//  Routers.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation
import Parsing
import URLRouting

// MARK: - rootRouter

public let rootRouter = OneOf {
    Route(.case(RootRoute.api)) {
        Path { "api" }
        apiRouter
    }
    Route(.case(RootRoute.home))
}

// MARK: - apiRouter

public let apiRouter = OneOf {
    Route(.case(APIRoute.groups)) {
        Path { "groups" }
        groupsRouter
    }
    Route(.case(APIRoute.campus)) {
        Path { "campus" }
        campusRouter
    }
    Route(.case(APIRoute.group)) {
        Path { "group" }
        Path { UUID.parser() }
        groupRouter
    }
}

// MARK: - campusRouter

public let campusRouter = OneOf {
    Route(.case(CampusRoute.getGroup)) {
        Path { "group" }
    }
    Route(.case(CampusRoute.currentСontrol)) {
        Path { "currentControl" }
    }
}

// MARK: - groupsRouter

public let groupsRouter = OneOf {
    Route(.case(GroupsRoute.all)) {
        Path { "all" }
    }
    Route(.case(GroupsRoute.forceRefresh)) {
        Path { "forceRefresh" }
    }
    Route(.case(GroupsRoute.search)) {
        Parse(.memberwise(GroupQuery.init)) {
            Query {
                Field("name")
            }
        }
    }
}

// MARK: - groupRouter

public let groupRouter = OneOf {
    Route(.case(GroupRoute.lessons)) {
        Path { "lessons" }
    }
}
