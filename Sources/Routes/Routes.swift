//
//  Routes.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation
import Parsing
import URLRouting

// MARK: RootRoute

public enum RootRoute: Equatable {
    case api(APIRoute)
    case home
}

// MARK: APIRoute

public enum APIRoute: Equatable {
    case groups(GroupsRoute)
    case group(UUID, GroupRoute)
}

// MARK: GroupsRoute

public enum GroupsRoute: Equatable {
    case all
    case forceRefresh
    case search(GroupQuery = .init())
}


// MARK: GroupRoute

public enum GroupRoute: Equatable {
    case lessons
}
