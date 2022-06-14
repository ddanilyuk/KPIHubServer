//
//  OneLineTag.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Parsing
import Foundation

struct OneLineTag: Parser {

    let tag: String

    init(_ tag: String) {
        self.tag = tag
    }

    typealias Input = Substring.UTF8View
    typealias Output = Void

    func parse(_ input: inout Substring.UTF8View) throws -> Void {
        try Parse {
            "<\(tag)/>".utf8
        }
        .parse(&input)
    }
}

