//
//  LessonV2.swift
//  
//
//  Created by Denys Danyliuk on 02.07.2022.
//

import Vapor

public struct LessonV2: Equatable {

    // MARK: - Position

    public enum Position: Int, Codable, CaseIterable, Equatable {
        case first = 1
        case second
        case third
        case fourth
        case fifth
        case sixth

        init(_ string: String) {
            switch string {
            case "8.30":
                self = .first

            case "10.25":
                self = .second

            case "12.20":
                self = .third

            case "14.15":
                self = .fourth

            case "16.10":
                self = .fifth

            case "18.30", "18.05":
                self = .sixth

            default:
                self = .first
            }
        }

        var description: [String] {
            switch self {
            case .first:
                return ["8.30"]

            case .second:
                return ["10.25"]

            case .third:
                return ["12.20"]

            case .fourth:
                return ["14.15"]

            case .fifth:
                return ["16.10"]

            case .sixth:
                return ["18.30", "18.05"]
            }
        }
    }

    // MARK: - Day

    public enum Day: Int, Codable, CaseIterable, Equatable {
        case monday = 1
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    // MARK: - Week

    public enum Week: Int, Codable, Equatable {
        case first = 1
        case second
    }

    public var names: [String]
    public var teachers: [String]?
    public var locations: [String]?
    public var type: String

    public let position: Position
    public let day: Day
    public let week: Week

}

// MARK: - Codable

extension LessonV2: Codable {

}
