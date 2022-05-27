//
//  RawLesson.swift
//  
//
//  Created by Denys Danyliuk on 18.05.2022.
//

import Foundation

struct RawLesson: Equatable {

    let names: [String]
    let teachers: [Teacher]?
    let locations: [String]?
    
}

// MARK: - Codable

extension RawLesson: Codable {

}
