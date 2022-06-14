//
//  CloseTag.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Parsing
import Foundation

struct CloseTag: Parser {

    typealias Input = Substring.UTF8View
    typealias Output = Void

    let tag: String

    init(_ tag: String) {
        self.tag = tag
    }

    func parse(_ input: inout Substring.UTF8View) throws -> Void {
        try Parse {
            "</\(tag)>".utf8
        }
        .parse(&input)
    }

}
