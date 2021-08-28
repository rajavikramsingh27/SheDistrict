//  ModelEditProfile.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/12/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


// MARK: - GetHobby
struct GetHobby: Codable {
    let hobbiesID, hibbiesName, created: String
    
    enum CodingKeys: String, CodingKey {
        case hobbiesID = "hobbies_id"
        case hibbiesName = "hibbies_name"
        case created
    }
}

var getHobbies:[GetHobby] = []

// MARK: - GetInterestElement
struct GetInterest: Codable {
    let interestID, interest: String
    let created: String
    let value: [ValueInterest]
    
    enum CodingKeys: String, CodingKey {
        case interestID = "interest_id"
        case interest, created, value
    }
}

// MARK: - Value
struct ValueInterest: Codable {
    let id, interestID, interestValue, created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case interestID = "interest_id"
        case interestValue = "interest_value"
        case created
    }
}


var getInterest:[GetInterest] = []

