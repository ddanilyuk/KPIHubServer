//
//  CampusQuery.swift
//  
//
//  Created by Denys Danyliuk on 02.06.2022.
//

import Foundation

public struct CampusLoginQuery {

    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

// MARK: Equatable

extension CampusLoginQuery: Encodable {

    enum CodingKeys: String, CodingKey {
        case username = "Username"
        case password = "Password"
    }
}

// MARK: Equatable

extension CampusLoginQuery: Equatable {

}
