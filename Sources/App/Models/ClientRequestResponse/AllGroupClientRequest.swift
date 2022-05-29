//
//  AllGroupClientRequest.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Vapor

struct AllGroupClientRequest: Content {

    public var prefixText: String
    public var count: Int

    public init(prefixText: String, count: Int) {
        self.prefixText = prefixText
        self.count = count
    }

}
