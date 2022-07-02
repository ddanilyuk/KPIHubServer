//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 02.07.2022.
//

import Vapor

struct LessonsResponseV2 {
    var id: UUID
    let lessons: [LessonV2]
}

extension LessonsResponseV2: Codable {

}

extension LessonsResponseV2: Content {

}
