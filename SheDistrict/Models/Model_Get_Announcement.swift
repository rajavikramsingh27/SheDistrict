//  Model_Get_Announcement.swift
//  SheDistrict
//  Created by Appentus Technologies on 1/30/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


var getAnnouncement:[GetAnnouncement] = []


// MARK: - GetAnnouncementElement
struct GetAnnouncement: Codable {
    let announcementID, announcementUserID, announcementCategoryID, announcementTitle: String
    let announcementDesc, created, announcementImage: String
    let user: [User]
    let category: [Category]
    
    enum CodingKeys: String, CodingKey {
        case announcementID = "announcement_id"
        case announcementUserID = "announcement_user_id"
        case announcementCategoryID = "announcement_category_id"
        case announcementTitle = "announcement_title"
        case announcementDesc = "announcement_desc"
        case created
        case announcementImage = "announcement_image"
        case user, category
    }
}

// MARK: - Category
struct Category: Codable {
    let categoryID: String
    let categoryName: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case categoryName = "category_name"
        case created
    }
}


// MARK: - User
struct User: Codable {
    let userID: String
    let userProfile: String
    let userName, userEmail, userPassword, userCountryCode: String
    let userMobile, userDob, userLoginType, userSocial: String
    let userDeviceType, userDeviceToken: String
    let userLat: String
    let userLang: String
    let userStatus, created: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userProfile = "user_profile"
        case userName = "user_name"
        case userEmail = "user_email"
        case userPassword = "user_password"
        case userCountryCode = "user_country_code"
        case userMobile = "user_mobile"
        case userDob = "user_dob"
        case userLoginType = "user_login_type"
        case userSocial = "user_social"
        case userDeviceType = "user_device_type"
        case userDeviceToken = "user_device_token"
        case userLat = "user_lat"
        case userLang = "user_lang"
        case userStatus = "user_status"
        case created
    }
}
