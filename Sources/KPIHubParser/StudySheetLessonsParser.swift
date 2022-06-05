//
//  StudySheetLessonsParser.swift
//  
//
//  Created by Denys Danyliuk on 03.06.2022.
//

import Foundation
import Parsing

public struct StudySheetLessonsParser: Parser {

    // MARK: - Typealiases

    public typealias Input = String
    public typealias Output = [StudySheetLesson]

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
            let semestr: Int
        }


        let trHeaderParser = Parse {
            TRHeader(year: $0, semestr: Int($1) ?? 0)
        } with: {
            Whitespace()
            Skip { PrefixThrough("=".utf8) }
            quotedField
            Skip { PrefixThrough("=".utf8) }
            quotedField
        }

        struct IdLink {
            let id: Int
            let link: String
        }

        struct IdLinkName {
            let idLink: IdLink
            let name: String
        }

        let idLinkParser = Parse { linkFirstPart, id, linkLastPart in
            IdLink(id: id, link: "\(linkFirstPart)\(id)\(linkLastPart)")
        } with: {
            "\"".utf8
            PrefixThrough("id=".utf8).map { String(Substring($0)) }
            Int.parser()
            PrefixUpTo("\"".utf8).map { String(Substring($0)) }
            "\"".utf8
        }

        let idLinkNameParser = Parse { idLink, name in
            IdLinkName(idLink: idLink, name: name)
        } with: {
            OpenTagV2("td")
            OpenTagV2("a") {
                Skip { PrefixThrough("=".utf8) }
                idLinkParser
            }
            upToNextTag
            CloseTagV2("a")
            CloseTagV2("td")
        }

        let teacherParser = Parse {
            OpenTagV2("td")
            Many {
                Prefix { $0 != .init(ascii: "<") && $0 != .init(ascii: ",") }
                    .map { String(Substring($0)) }
            } separator: {
                ",".utf8
                Whitespace()
            }
            CloseTagV2("td")
        }

        let oneRowParser = Parse { trHeader, idLinkName, teachers in
            StudySheetLesson(
                id: idLinkName.idLink.id,
                year: trHeader.year,
                semester: trHeader.semestr,
                link: idLinkName.idLink.link,
                name: idLinkName.name,
                teachers: teachers
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
                idLinkNameParser
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
