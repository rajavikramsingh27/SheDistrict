//  Model_New_Post.swift
//  SheDistrict
//  Created by Appentus Technologies on 1/29/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation

// MARK: - PostcategoryElement
struct Postcategory: Codable {
    let categoryID, categoryName, created: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case categoryName = "category_name"
        case created
    }
}

var postcategory:[Postcategory] = []
