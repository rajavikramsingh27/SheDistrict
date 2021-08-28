//  Model_Chat.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import Foundation


// MARK: - GetMessageElement
struct GetMessage: Codable {
    let chatID, chatRoomID, chatMessage, chatFile: String
    let chatFileType, created, roomID, friID: String
    let userID: String

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case chatRoomID = "chat_room_id"
        case chatMessage = "chat_message"
        case chatFile = "chat_file"
        case chatFileType = "chat_file_type"
        case created
        case roomID = "room_id"
        case friID = "fri_id"
        case userID = "user_id"
    }
}


var getMessage:[GetMessage] = []
var getMessage_send:GetMessage?

