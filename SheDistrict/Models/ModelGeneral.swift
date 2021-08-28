//
//  ModelGeneral.swift
//  SheDistrict
//
//  Created by Appentus Technologies on 2/13/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation

struct GeneralInfo: Codable {
    let id, appAbout, appUpdate, ceoMsg: String
    let ceoSocialLink, created: String

    enum CodingKeys: String, CodingKey {
        case id
        case appAbout = "app_about"
        case appUpdate = "app_update"
        case ceoMsg = "ceo_msg"
        case ceoSocialLink = "ceo_social_link"
        case created
    }
}

var generalInfo:[GeneralInfo] = []
