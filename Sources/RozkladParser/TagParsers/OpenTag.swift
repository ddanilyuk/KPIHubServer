//
//  OpenTag.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Parsing
import Foundation

struct OpenTag<CustomOutput, NestedParser: Parser>: Parser {

    typealias Input = Substring
    typealias Output = CustomOutput

    let tag: String
    let nestedParser: AnyParser<Substring, CustomOutput>

    init(
        _ tag: String,
        @ParserBuilder _ nestedParser: () -> NestedParser
    ) where NestedParser.Input == Substring, CustomOutput == NestedParser.Output {
        self.tag = tag
        self.nestedParser = nestedParser().eraseToAnyParser()
    }

    init(
        _ tag: String
    ) where NestedParser == AnyParser<Substring, Void>, CustomOutput == Void {
        self.tag = tag
        let some = Parse { Skip { Rest().replaceError(with: ""[...]) } }
            .eraseToAnyParser()
        self.nestedParser = some
    }

    func parse(_ input: inout Substring) throws -> CustomOutput {
        var result = try Parse {
            "<\(tag)"
            Prefix { $0 != ">" }
            ">"
        }
            .parse(&input)

        return try nestedParser.parse(&result)
    }
}

struct OpenTagV2<CustomOutput, NestedParser: Parser>: Parser {

    typealias Input = Substring.UTF8View
    typealias Output = CustomOutput

    let tag: String
    let nestedParser: AnyParser<Substring.UTF8View, CustomOutput>

    init(
        _ tag: String,
        @ParserBuilder _ nestedParser: () -> NestedParser
    ) where NestedParser.Input == Substring.UTF8View, CustomOutput == NestedParser.Output {
        self.tag = tag
        self.nestedParser = nestedParser().eraseToAnyParser()
    }

    init(
        _ tag: String
    ) where NestedParser == AnyParser<Substring.UTF8View, Void>, CustomOutput == Void {
        self.tag = tag
        let some = Parse { Skip { Rest().replaceError(with: ""[...].utf8) } }
            .eraseToAnyParser()
        self.nestedParser = some
    }

    func parse(_ input: inout Substring.UTF8View) throws -> CustomOutput {
        var result = try Parse {
            "<\(tag)".utf8
            Prefix { $0 != .init(ascii: ">") }
            ">".utf8
        }
        .parse(&input)

        return try nestedParser.parse(&result)
    }
}
