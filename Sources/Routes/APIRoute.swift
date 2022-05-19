//
//  APIRoute.swift
//  
//
//  Created by Denys Danyliuk on 19.05.2022.
//

import Foundation
import Parsing
import URLRouting


public struct GroupSearch: Equatable {
    public let name: String

    public init(name: String = "") {
        self.name = name
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
    case search(GroupSearch = .init())
}

public let groupParser = OneOf {
    Route(.case(GroupRoute.lessons))
}

public let groupsRouter = OneOf {
    Route(.case(GroupsRoute.search)) {
        Parse(.memberwise(GroupSearch.init)) {
            Query {
                Field("name", default: "")
            }
        }
    }
    Route(.case(GroupsRoute.all))
}

public let apiRouter = OneOf {
    Route(.case(APIRoute.groups)) {
        Path { "groups" }
        groupsRouter
    }
    Route(.case(APIRoute.group)) {
        Path { "group" }
        Path { UUID.parser() }
        groupParser
    }
}

public let router = OneOf {
    Route(.case(SiteRoute.api)) {
        Path { "api" }
        apiRouter
    }
    Route(.case(SiteRoute.home))
}

//public struct LessonsQuery: Equatable {
//
//    public var groupName: String = ""
//
//    public init(groupName: String = "") {
//        self.groupName = groupName
//    }
//}
//
//public enum LessonsRoute: Equatable {
//    case lessonGroups
//}
