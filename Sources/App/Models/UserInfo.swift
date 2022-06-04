//
//  UserInfo.swift
//  
//
//  Created by Denys Danyliuk on 04.06.2022.
//

import Foundation
import Vapor

struct UserInfo: Codable, Equatable {

    // MARK: - StudyGroup

    struct InfoItem: Codable, Equatable {
        let id: Int
        let name: String
    }

    // MARK: - Profile
    
    struct Profile: Codable, Equatable {
        let id: Int
        let profile: String
        let subdivision: InfoItem
    }

    let modules: [String]
    let position: [InfoItem]
    let subdivision: [InfoItem]
    let studyGroup: InfoItem
    let sid: String
    let email: String
    let scientificInterest: String
    let username: String
    let tgAuthLinked: Bool
    let profiles: [Profile]
    let id: Int
    let userIdentifier: String
    let fullName: String
    let photo: String
    let credo: String
}

// MARK: UserInfo + Content

extension UserInfo: Content {

}
