//
//  Model+unique.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation
import FluentSQL

extension Array where Element: Model {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element.IDValue>()
        for element in self {
            if let elementId = element.id, !added.contains(elementId) {
                buffer.append(element)
                added.insert(elementId)
            } else {
                Swift.print("!!!!!!!!!! NOT UNIQUE \(element)")
            }
        }
        return buffer
    }
}
