//
//  CurrentControlParser.swift
//  
//
//  Created by Denys Danyliuk on 03.06.2022.
//

import Parsing

public struct StudySheetDetailParser: Parser {

    // MARK: - Typealiases

    public typealias Input = String
    public typealias Output = [StudySheetDetailRow]

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public methods

    public func parse(_ input: inout Input) throws -> Output {

        let upToNextTag = PrefixUpTo("<".utf8).map { String(Substring($0)) }

        let fieldParser = Parse {
            OpenTagV2("td")
            upToNextTag
            CloseTagV2("td")
        }
        let allFieldsParser = Parse { date, mark, type, teacher, note in
            StudySheetDetailRow(
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
            OpenTagV2("tr")
            allFieldsParser
            CloseTagV2("tr")
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
