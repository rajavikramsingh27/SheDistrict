//  SheRule.swift
//  SheDistrict
//  Created by Appentus Technologies on 1/27/20.
//  Copyright © 2020 appentus. All rights reserved.

import Foundation

var sheRules:[SheRules] = []
//var ServiceprofileRes: [ServiceProfileRes] = []

// MARK: - SheRule
struct SheRules: Codable {
    var ruleID, ruleTitle, ruleDiscription, created: String
    
    enum CodingKeys: String, CodingKey {
        case ruleID = "rule_id"
        case ruleTitle = "rule_title"
        case ruleDiscription = "rule_discription"
        case created
    }
}


//typealias SheRules = [SheRule]

