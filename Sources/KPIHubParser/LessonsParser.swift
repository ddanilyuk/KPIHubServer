//
//  LessonsParser.swift
//  
//
//  Created by Denys Danyliuk on 19.05.2022.
//

import Foundation
import Parsing

public struct LessonsParser: Parser {

    // MARK: - Typealiases

    public typealias Input = String
    public typealias Output = [Lesson]

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public methods

    public func parse(_ input: inout String) throws -> [Lesson] {

        let upToNextTag = PrefixUpTo("<".utf8)
        let quotedField = Parse {
            "\"".utf8
            PrefixUpTo("\"".utf8)
            "\"".utf8
        }

        // MARK: - Lesson name

        let nameParser = Parse {
            OpenTag("a")
            upToNextTag.map { String(Substring($0)) }
            CloseTag("a")
        }
        let multipleNamesParser = Parse {
            OpenTag("span")
            Many {
                nameParser
            } separator: {
                Whitespace()
                Skip { PrefixUpTo("<".utf8) }
                Peek { "<a".utf8 }
            } terminator: {
                Skip { PrefixThrough("</span>".utf8) }
            }
            OneLineTag("br")
        }

        // MARK: - Teacher

        let teacherFullNameParser = Parse {
            Skip { PrefixThrough("title=".utf8) }
            quotedField.map { String(Substring($0)) }
        }
        let teacherShortNameParser = Parse {
            upToNextTag.map { String(Substring($0)) }
        }
        let teacherParser = Parse(Teacher.init) {
            OpenTag("a") {
                teacherFullNameParser
            }
            teacherShortNameParser
            CloseTag("a")
        }
        let multipleTeachersParser = Parse {
            Optionally {
                Many {
                    teacherParser
                } separator: {
                    Whitespace()
                    Skip { PrefixUpTo("<".utf8) }
                    Peek { "<a".utf8 }
                }
            }
            OneLineTag("br")
        }

        // MARK: - Location

        let locationWithLinkParser = Parse {
            OpenTag("a")
            upToNextTag.map { String(Substring($0)) }
            CloseTag("a")
        }
        let locationPlainTextParser = Parse {
            Whitespace()
            Prefix { $0 != .init(ascii: "<") && $0 != .init(ascii: ",") }
                .map { String(Substring($0)) }
        }
        let multipleLocationParser = Parse {
            Optionally {
                Many {
                    OneOf {
                        locationWithLinkParser
                        locationPlainTextParser
                    }
                } separator: {
                    ",".utf8
                    Whitespace()
                }
            }
        }

        // MARK: - Lesson

        let lessonCellParser = Parse {
            OpenTag("td")
            Optionally {
                Parse(RawLesson.init) {
                    multipleNamesParser
                    multipleTeachersParser
                    multipleLocationParser
                }
            }
            CloseTag("td")
        }

        // MARK: - Row

        /// Cell with pair number and time
        let skipFirstCell = Parse {
            OpenTag("td")
            Skip { PrefixThrough("</td>".utf8) }
        }

        let rowParser = Parse {
            Parse {
                Whitespace()
                OpenTag("tr")
                Whitespace()
            }
            skipFirstCell
            Many(6, element: { lessonCellParser })
            Parse {
                Whitespace()
                CloseTag("tr")
                Whitespace()
            }
        }

        // MARK: - Table

        let skipTableHeader = Parse {
            Skip {
                PrefixThrough("<table".utf8)
                PrefixThrough(">".utf8)
                PrefixThrough("<tr".utf8)
                PrefixThrough("</tr>".utf8)
            }
        }

        let firstTable = Parse {
            skipTableHeader
            Many(6, element: { rowParser })
        }
            .replaceError(
                with: Array(
                    repeating: Array(repeating: nil, count: Lesson.Position.allCases.count),
                    count: Lesson.Day.allCases.count
                )
            )

        let secondTable = Parse {
            skipTableHeader
            Many(6, element: { rowParser })
        }
            .replaceError(
                with: Array(
                    repeating: Array(repeating: nil, count: Lesson.Position.allCases.count),
                    count: Lesson.Day.allCases.count
                )
            )

        let allTables = Parse {
            (firstWeekMatrix: $0.0, secondWeekMatrix: $0.1)
        } with: {
            firstTable
            secondTable
            Skip { Rest() }
        }

        let fullParser = allTables.map { output -> [Lesson] in
            var firstWeekLessons: [Lesson] = []
            var secondWeekLessons: [Lesson] = []
            for (dayIndex, day) in Lesson.Day.allCases.enumerated() {
                for (positionIndex, position) in Lesson.Position.allCases.enumerated() {
                    if let rawLessonFromFirstTable = output.firstWeekMatrix[positionIndex][dayIndex] {
                        let lesson = Lesson(
                            rawLesson: rawLessonFromFirstTable,
                            position: position,
                            day: day,
                            week: .first
                        )
                        firstWeekLessons.append(lesson)
                    }
                    if let rawLessonFromSecondTable = output.secondWeekMatrix[positionIndex][dayIndex] {
                        let lesson = Lesson(
                            rawLesson: rawLessonFromSecondTable,
                            position: position,
                            day: day,
                            week: .second
                        )
                        secondWeekLessons.append(lesson)
                    }
                }
            }
            return firstWeekLessons + secondWeekLessons
        }
        return try fullParser.parse(input)
    }

}
