//
//  GroupV2.swift
//  
//
//  Created by Denys Danyliuk on 02.07.2022.
//

import Vapor

struct GroupV2: Content {

    var id: UUID?
    var name: String
    var faculty: String?

}
