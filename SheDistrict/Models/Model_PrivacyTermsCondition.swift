//  Model_PrivacyTermsCondition.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/5/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation

var getPrivacyTerms:GetPrivacyTerms?

import Foundation

// MARK: - GetPrivacyTerms
struct GetPrivacyTerms: Codable {
    let contentID, privacyPolicy, termsConditions, created: String
    
    enum CodingKeys: String, CodingKey {
        case contentID = "content_id"
        case privacyPolicy = "privacy_policy"
        case termsConditions = "terms_conditions"
        case created
    }
}
