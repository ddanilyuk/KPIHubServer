//
//  StudySheetParser.swift
//  
//
//  Created by Denys Danyliuk on 03.06.2022.
//

import Foundation
import Parsing

public struct StudySheetParser: Parser {

    // MARK: - Typealiases

    public typealias Input = String
    public typealias Output = [StudySheetRow]

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public methods

    public func parse(_ input: inout Input) throws -> Output {

        let upToNextTag = PrefixUpTo("<".utf8).map { String(Substring($0)) }
        let quotedField = Parse {
            "\"".utf8
            PrefixUpTo("\"".utf8).map { String(Substring($0)) }
            "\"".utf8
        }

        struct TRHeader {
            let year: String
            let semestr: String
        }


        let trHeaderParser = Parse {
            TRHeader(year: $0, semestr: $1)
        } with: {
            Whitespace()
            Skip { PrefixThrough("=".utf8) }
            quotedField
            Skip { PrefixThrough("=".utf8) }
            quotedField
        }

        struct LinkName {
            let link: String
            let name: String
        }

        let linkNameParser = Parse {
            LinkName(link: $0, name: $1)
        } with: {
            OpenTagV2("td")
            OpenTagV2("a") {
                Skip { PrefixThrough("=".utf8) }
                quotedField
            }
            upToNextTag
            CloseTagV2("a")
            CloseTagV2("td")
        }

        let teacherParser = Parse {
            OpenTagV2("td")
            upToNextTag
            CloseTagV2("td")
        }

        let oneRowParser = Parse { trHeader, linkName, teacher in
            StudySheetRow(
                year: trHeader.year,
                semester: trHeader.semestr,
                link: linkName.link,
                name: linkName.name,
                teacher: teacher
            )
        } with: {
            Whitespace()
            Parse {
                OpenTagV2("tr") {
                    trHeaderParser
                }
                Whitespace()
            }
            Parse {
                linkNameParser
                Whitespace()
            }
            Parse {
                teacherParser
                Whitespace()
            }
            CloseTagV2("tr")
        }


        let rowsParser = Many {
            oneRowParser
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
