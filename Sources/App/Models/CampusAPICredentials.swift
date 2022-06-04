//
//  CampusAPICredentials.swift
//  
//
//  Created by Denys Danyliuk on 04.06.2022.
//

import Foundation

struct CampusAPICredentials: Equatable, Codable {

    let accessToken: String
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case sessionId
    }
}
