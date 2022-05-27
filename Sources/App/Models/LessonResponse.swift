//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor
import Routes
import KPIHubParser

struct LessonResponse {
    var id: UUID
    let lessons: [Lesson]
}

extension LessonResponse: Codable {

}

extension LessonResponse: Content {
    
}
