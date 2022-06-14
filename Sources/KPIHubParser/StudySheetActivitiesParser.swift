//
//  StudySheetActivitiesParser.swift
//  
//
//  Created by Denys Danyliuk on 03.06.2022.
//

import Parsing

public struct StudySheetActivitiesParser: Parser {

    // MARK: - Typealiases

    public typealias Input = String
    public typealias Output = [StudySheetActivity]

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public methods

    public func parse(_ input: inout Input) throws -> Output {

        let upToNextTag = PrefixUpTo("<".utf8).map { String(Substring($0)) }

        let fieldParser = Parse {
            Whitespace()
            OpenTag("td")
            upToNextTag
            CloseTag("td")
            Whitespace()
        }
        let allFieldsParser = Parse { date, mark, type, teacher, note in
            StudySheetActivity(
                date: date,
                mark: mark,
                type: type,
                teacher: teacher,
                note: note
            )
        } with: {
            fieldParser
            fieldParser
            fieldParser
            fieldParser
            fieldParser
        }

        let rowsParser = Many {
            Whitespace()
            OpenTag("tr")
            Parse {
                Whitespace()
                allFieldsParser
                Whitespace()
            }
            CloseTag("tr")
            Whitespace()
        }

        let fullParser = Parse {
            Skip { PrefixThrough("<tbody>".utf8) }
            Whitespace()
            rowsParser
            Skip { Rest() }
        }

        return try fullParser.parse(input)
    }

}
