//
//  StudySheetItem.swift
//  
//
//  Created by Denys Danyliuk on 05.06.2022.
//

import Vapor
import KPIHubParser

struct StudySheetItem: Content {
    let id: Int
    let year: String
    let semester: Int
    let link: String
    let name: String
    let teachers: [String]

    let activities: [StudySheetActivity]

    init(lesson: StudySheetLesson, activities: [StudySheetActivity]) {
        self.id = lesson.id
        self.year = lesson.year
        self.semester = lesson.semester
        self.link = lesson.link
        self.name = lesson.name
        self.teachers = lesson.teachers

        self.activities = activities
    }

}
