//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation
import Parsing

public struct GroupParser: Parser {

    public let groupName: String

    // MARK: - Lifecycle

    public init(groupName: String) {
        self.groupName = groupName
    }

    public func parse(_ input: inout String) throws -> [Group] {

        let singleIdParser = Parse {
            Parse {
                Skip { PrefixThrough("ViewSchedule.aspx?g=") }
                PrefixUpTo("\"").map { UUID(uuidString: String($0)) }
            }
            Parse {
                "\">"
                PrefixUpTo("<").map { String($0) }
            }
            .replaceError(with: groupName)
        }.map(Group.init(id:name:))

        let multipleIdParser = Parse {
            singleIdParser
            singleIdParser
        }.map { [$0, $1] }

        let parser = Parse {
            OneOf {
                multipleIdParser
                singleIdParser.map { [$0] }
            }
            Skip { Rest() }
        }
        return try parser.parse(input)
    }

}
