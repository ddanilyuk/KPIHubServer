//
//  StudySheetLesson.swift
//  
//
//  Created by Denys Danyliuk on 03.06.2022.
//

import Foundation

public struct StudySheetLesson: Codable {

    public let id: Int
    public let year: String
    public let semester: Int
    public let link: String
    public let name: String
    public let teachers: [String]

}
