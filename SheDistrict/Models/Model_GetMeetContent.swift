//  Model_GetMeetContent.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/6/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


// MARK: - GetMeetContentElement
struct GetMeetContent: Codable {
    let contentID, howItsWork, why, ruleTips: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case contentID = "content_id"
        case howItsWork = "how_its_work"
        case why
        case ruleTips = "rule_tips"
        case created
    }
}


var getMeetContent:[GetMeetContent] = []

