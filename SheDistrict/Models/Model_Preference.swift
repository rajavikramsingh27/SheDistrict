//  Model_Preference.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/4/20.
//  Copyright © 2020 appentus. All rights reserved.


//   let preference = try? newJSONDecoder().decode(Preference.self, from: jsonData)

import Foundation

// MARK: - Preference
struct Preference: Codable {
    let preferenceID, preference,created: String
    let values: [Preference_Value]

    enum CodingKeys: String, CodingKey {
        case preferenceID = "preference_id"
        case created = "created"
        case preference, values
    }
}

//enum Created: String, Codable {
//    case the20200124022039 = "2020-01-24 02:20:39"
//}

// MARK: - Value
struct Preference_Value: Codable {
    let preferenceValueID, preferenceID, valueName, created: String

    enum CodingKeys: String, CodingKey {
        case preferenceValueID = "preference_value_id"
        case preferenceID = "preference_id"
        case valueName = "value_name"
        case created
    }
}


var preference:[Preference] = []

