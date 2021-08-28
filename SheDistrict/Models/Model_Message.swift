
//
//  Model_Message.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


// MARK: - GetFriendList
struct GetFriendList: Codable {
    let userID, userProfile, userName, userEmail: String
    let userPassword, userCountryCode, userMobile, userDob: String
    let userLoginType, userSocial, userDeviceType, userDeviceToken: String
    let userLat, userLang, userStatus, created: String
    let role, distance: String

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
        case created, role, distance
    }
}

enum UserDeviceToken: String, Codable {
    case empty = ""
    case fcm = "fcm"
}

var getFriendList:[GetFriendList] = []



// MARK: - ChatList
struct ChatList: Codable {
    let roomID, newFriID, friName, friImage: String
    let lastMessage, lastMessageCreated: String

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case newFriID = "new_fri_id"
        case friName = "fri_name"
        case friImage = "fri_image"
        case lastMessage = "last_message"
        case lastMessageCreated = "last_message_created"
    }
}



var chatList:[ChatList] = []

