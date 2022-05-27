//
//  LessonsResponse.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import Routes
import KPIHubParser

struct LessonsResponse {
    var id: UUID
    let lessons: [Lesson]
}

extension LessonsResponse: Codable {

}

extension LessonsResponse: Content {
    
}
