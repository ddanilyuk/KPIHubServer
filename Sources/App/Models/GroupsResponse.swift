//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor

struct GroupsResponse {
    let numberOfGroups: Int
    let groups: [GroupModel]
}

extension GroupsResponse: Codable {

}

extension GroupsResponse: Content {
    
}
