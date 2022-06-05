//
//  StudySheetResponse.swift
//  
//
//  Created by Denys Danyliuk on 05.06.2022.
//

import Vapor

struct StudySheetResponse: Content {
    let studySheet: [StudySheetItem]
}
