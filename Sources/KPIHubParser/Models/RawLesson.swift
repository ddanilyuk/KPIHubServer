//
//  RawLesson.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Foundation

struct RawLesson: Equatable {

    let names: [String]
    let teachers: [String]?
    let locations: [String]?
    let type: String

    init(names: [String], teachers: [Teacher]?, locations: [String]?) {
        self.names = names
        self.teachers = teachers?.map { $0.shortName }
        self.locations = locations
        self.type = RawLesson.type(for: locations?.first)
    }

    static func type(for location: String?) -> String {
        switch location?.lowercased() ?? "" {
        case let string where string.contains("лек"):
            return "Лекція"

        case let string where string.contains("прак"):
            return "Практика"

        case let string where string.contains("лаб"):
            return "Лабораторна"

        default:
            return "Невідомо"
        }
    }
    
}

// MARK: - Codable

extension RawLesson: Codable {

}
