//
//  Group.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation

public struct Group {
    public let id: UUID?
    public let name: String
}

extension Group: Codable {

}
