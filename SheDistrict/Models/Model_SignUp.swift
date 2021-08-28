//  Model_SignUp.swift
//  SheDistrict
//  Created by Appentus Technologies on 1/23/20.
//  Copyright © 2020 appentus. All rights reserved.

import Foundation

var signUp:SignUp?

// MARK: - SignUp
struct SignUp: Codable {
    let userID, userProfile, userName, userEmail: String
    let userPassword, userCountryCode, userMobile, userDob: String
    let userLoginType, userSocial, userDeviceType, userDeviceToken: String
    let userLat, userLang, userStatus, created: String
    let role, aboutMe, friendLike, describeMe: String
    let hobbies, interestInfo, personalInfo, allowMsg: String
    let premiumData, hideProfile, hideActivity, stopInvite: String
    let hideLocation, hideAge, userDeactive, pushStatus: String
    let pushSetting, isUserLike, userLike: String
    let userDetails: [UserDetail]
    let userPhotos: [UserPhoto]
    
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
        case created, role
        case aboutMe = "about_me"
        case friendLike = "friend_like"
        case describeMe = "describe_me"
        case hobbies
        case interestInfo = "interest_info"
        case personalInfo = "personal_info"
        case allowMsg = "allow_msg"
        case premiumData = "premium_data"
        case hideProfile = "hide_profile"
        case hideActivity = "hide_activity"
        case stopInvite = "stop_invite"
        case hideLocation = "hide_location"
        case hideAge = "hide_age"
        case userDeactive = "user_deactive"
        case pushStatus = "push_status"
        case pushSetting = "push_setting"
        case isUserLike = "is_user_like"
        case userLike = "user_like"
        case userDetails = "user_details"
        case userPhotos = "user_photos"
    }
}



// MARK: - UserDetail
struct UserDetail: Codable {
    let detailID, detailUserID, userBio, userBioImage: String
    let userBioVideo, userIntroVideo, created: String

    enum CodingKeys: String, CodingKey {
        case detailID = "detail_id"
        case detailUserID = "detail_user_id"
        case userBio = "user_bio"
        case userBioImage = "user_bio_image"
        case userBioVideo = "user_bio_video"
        case userIntroVideo = "user_intro_video"
        case created
    }
}

// MARK: - UserPhoto
struct UserPhoto: Codable {
    let photoID, userPhotos, photosUserID, created: String

    enum CodingKeys: String, CodingKey {
        case photoID = "photo_id"
        case userPhotos = "user_photos"
        case photosUserID = "photos_user_id"
        case created
    }
}
