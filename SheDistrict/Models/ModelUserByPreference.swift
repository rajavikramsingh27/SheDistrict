//  ModelUserByPreference.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation

// MARK: - Age
struct UserAccordingPreference: Codable {
    let userID, userName: String
    let userProfile: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userProfile = "user_profile"
    }
}


var userAccordingPreference:[UserAccordingPreference] = []

