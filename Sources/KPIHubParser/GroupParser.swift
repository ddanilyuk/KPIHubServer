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

        let linkParser = Parse {
            Skip { PrefixThrough("ViewSchedule.aspx?g=") }
            PrefixUpTo("\"").map { UUID(uuidString: String($0)) }
        }
        let singleIdParser = Parse {
            linkParser
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
                linkParser.map { [Group(id: $0, name: groupName)] }
            }
            Skip { Rest() }
        }
        return try parser.parse(input)
    }

}
