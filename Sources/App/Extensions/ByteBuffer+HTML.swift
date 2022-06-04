//
//  ByteBuffer+HTML.swift
//  
//
//  Created by Denys Danyliuk on 04.06.2022.
//

import Vapor
import Foundation

extension ByteBuffer {

    public func htmlString(encoding: String.Encoding = .utf8) throws -> String {
        let data = Data(buffer: self)
        guard
            let html = String(data: data, encoding: encoding)
        else {
            throw Abort(.internalServerError)
        }
        return html
    }

}

extension Optional where Wrapped == ByteBuffer {

    public func htmlString(encoding: String.Encoding = .utf8) throws -> String {
        switch self {
        case let .some(buffer):
            return try buffer.htmlString(encoding: encoding)
        case .none:
            throw Abort(.internalServerError)
        }
    }

}
