//
//  Lesson.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Foundation

public struct Lesson: Equatable {

    // MARK: - Position

    public enum Position: Int, Codable, CaseIterable, Equatable {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
    }

    // MARK: - Day

    public enum Day: Int, Codable, CaseIterable, Equatable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    // MARK: - Week

    public enum Week: Codable, Equatable {
        case first
        case second
    }

    public let names: [String]
    public let teachers: [Teacher]?
    public let locations: [String]?

    public let position: Position
    public let day: Day
    public let week: Week

    init(
        rawLesson: RawLesson,
        position: Position,
        day: Day,
        week: Week
    ) {
        self.names = rawLesson.names
        self.teachers = rawLesson.teachers
        self.locations = rawLesson.locations
        self.day = day
        self.week = week
        self.position = position
    }

}

// MARK: - Codable

extension Lesson: Codable {

}
