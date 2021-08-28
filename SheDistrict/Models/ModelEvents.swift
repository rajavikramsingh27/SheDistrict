//  ModelEvents.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/10/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


// MARK: - PendingElement
//struct ScheduleEvents: Codable {
//    let meetingID, meetingUserID, meetingFriendID, meetingSubject: String?
//    let meetingReason, meetingDate, meetingTime, meetingLocation: String?
//    let created, meetingStatus, userID, userProfile: String?
//    let userName, userEmail, userPassword, userCountryCode: String?
//    let userMobile, userDob, userLoginType, userSocial: String?
//    let userDeviceType, userDeviceToken, userLat, userLang: String?
//    let userStatus, role, aboutMe, friendLike: String?
//    let describeMe, hobbies, personalInfo, text: String?
//
//    enum CodingKeys: String, CodingKey {
//        case meetingID = "meeting_id"
//        case meetingUserID = "meeting_user_id"
//        case meetingFriendID = "meeting_friend_id"
//        case meetingSubject = "meeting_subject"
//        case meetingReason = "meeting_reason"
//        case meetingDate = "meeting_date"
//        case meetingTime = "meeting_time"
//        case meetingLocation = "meeting_location"
//        case created
//        case meetingStatus = "meeting_status"
//        case userID = "user_id"
//        case userProfile = "user_profile"
//        case userName = "user_name"
//        case userEmail = "user_email"
//        case userPassword = "user_password"
//        case userCountryCode = "user_country_code"
//        case userMobile = "user_mobile"
//        case userDob = "user_dob"
//        case userLoginType = "user_login_type"
//        case userSocial = "user_social"
//        case userDeviceType = "user_device_type"
//        case userDeviceToken = "user_device_token"
//        case userLat = "user_lat"
//        case userLang = "user_lang"
//        case userStatus = "user_status"
//        case role
//        case aboutMe = "about_me"
//        case friendLike = "friend_like"
//        case describeMe = "describe_me"
//        case hobbies
//        case personalInfo = "personal_info"
//        case text
//    }
//}


struct ScheduleEvents: Codable {
    let meetingID, meetingUserID, meetingFriendID, meetingSubject: String?
    let meetingReason, meetingDate, meetingTime, meetingLocation: String?
    let created, meetingStatus, userName, userProfile: String?
    let text, type: String?
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meeting_id"
        case meetingUserID = "meeting_user_id"
        case meetingFriendID = "meeting_friend_id"
        case meetingSubject = "meeting_subject"
        case meetingReason = "meeting_reason"
        case meetingDate = "meeting_date"
        case meetingTime = "meeting_time"
        case meetingLocation = "meeting_location"
        case created
        case meetingStatus = "meeting_status"
        case userName = "user_name"
        case userProfile = "user_profile"
        case text, type
    }
}

var scheduleEvents:[ScheduleEvents] = []


