//
//  GroupsResponseV2.swift
//  
//
//  Created by Denys Danyliuk on 02.07.2022.
//

import Vapor

struct GroupsResponseV2: Content {

    let numberOfGroups: Int
    let groups: [GroupV2]

}
