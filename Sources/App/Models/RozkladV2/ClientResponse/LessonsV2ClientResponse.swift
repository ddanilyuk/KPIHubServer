//
//  LessonsV2ClientResponse.swift
//  
//
//  Created by Denys Danyliuk on 02.07.2022.
//

import Vapor

struct LessonsV2ClientResponse: Content {

    let data: Data

    struct Data: Content {
        let scheduleFirstWeek: [Day]
        let scheduleSecondWeek: [Day]
    }

    struct Day: Content {
        let day: String
        let pairs: [Pair]
    }

    struct Pair: Content {
        let teacherName: String
        let lecturerId: String
        let type: String
        let time: String
        let name: String
        let place: String
        let tag: String
    }

}

extension LessonsV2ClientResponse {

    func lessonsV2() -> [LessonV2] {
        let firstWeek = getWeekLessons(from: data.scheduleFirstWeek, week: .first)
        let secondWeek = getWeekLessons(from: data.scheduleSecondWeek, week: .second)
        return firstWeek + secondWeek
    }

    private func getWeekLessons(from days: [LessonsV2ClientResponse.Day], week: LessonV2.Week) -> [LessonV2] {
        days
            .enumerated()
            .flatMap { index, day -> [LessonV2] in
                day.pairs
                    .reduce(into: []) { partialResult, pair in
                        let firstIndex = partialResult.firstIndex(where: { $0.position.description.contains(pair.time) })
                        if let firstIndex = firstIndex {
                            var old = partialResult.remove(at: firstIndex)
                            if !old.names.contains(pair.name) {
                                old.names.append(pair.name)
                            }
                            if !(old.teachers?.contains(pair.teacherName) ?? false) {
                                old.teachers?.append(pair.teacherName)
                            }
                            if !(old.locations?.contains(pair.place) ?? false) {
                                old.locations?.append(pair.place)
                            }
                            partialResult.insert(old, at: firstIndex)

                        } else {
                            partialResult.append(
                                LessonV2(
                                    names: [pair.name],
                                    teachers: [pair.teacherName],
                                    locations: [pair.place],
                                    type: pair.type,
                                    position: .init(pair.time),
                                    day: LessonV2.Day(rawValue: index + 1) ?? .monday,
                                    week: week
                                )
                            )
                        }
                    }
                    .sorted { lhs, rhs in
                        lhs.position.rawValue < rhs.position.rawValue
                    }
            }
    }
}
