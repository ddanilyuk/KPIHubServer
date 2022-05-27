//
//  File.swift
//  
//
//  Created by Denys Danyliuk on 27.05.2022.
//

import Foundation

public struct GroupQuery: Equatable {
    public let groupName: String

    public init(groupName: String = "") {
        self.groupName = groupName
    }
}
