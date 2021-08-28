//
//  ModelPersonalInfo.swift
//  SheDistrict
//
//  Created by Appentus Technologies on 2/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import Foundation


struct PersonalInfo: Codable {
    let id, infoKey, infoValue, created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case infoKey = "info_key"
        case infoValue = "info_value"
        case created
    }
}

var personalInfo:[PersonalInfo] = []
