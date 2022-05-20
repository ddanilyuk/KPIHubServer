//
//  APIRoute.swift
//  
//
//  Created by Denys Danyliuk on 19.05.2022.
//

import Foundation
import Parsing
import URLRouting


public struct GroupQuery: Equatable {
    public let groupName: String

    public init(groupName: String = "") {
        self.groupName = groupName
    }
}

public enum SiteRoute: Equatable {
    case api(APIRoute)
    case home
}


public enum APIRoute: Equatable {
    case groups(GroupsRoute)
    case group(UUID, GroupRoute)
}

public enum GroupRoute: Equatable {
    case lessons
}

public enum GroupsRoute: Equatable {
    case all
    case forceRefresh
    case search(GroupQuery = .init())
}

public let groupRouter = OneOf {
    Route(.case(GroupRoute.lessons)) {
        Path { "lessons" }
    }
}

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

public let apiRouter = OneOf {
    Route(.case(APIRoute.groups)) {
        Path { "groups" }
        groupsRouter
    }
    Route(.case(APIRoute.group)) {
        Path { "group" }
        Path { UUID.parser() }
        groupRouter
    }
}

public let router = OneOf {
    Route(.case(SiteRoute.api)) {
        Path { "api" }
        apiRouter
    }
    Route(.case(SiteRoute.home))
}
