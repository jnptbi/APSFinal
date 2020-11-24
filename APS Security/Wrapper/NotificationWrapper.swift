//
//  NotificationWrapper.swift
//  APS Security
//
//  Created by Vishal Patel on 03/11/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct NotificationWrapper : Codable {
    let status : Int?
    let message : String?
    let data : [NotificationData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([NotificationData].self, forKey: .data)
    }

}


struct NotificationData : Codable, Identifiable, Hashable {
    var id = UUID()
    let notification_id : String?
    let notification_title : String?
    let notification_body : String?
    let notification_user_id : String?
    let notification_datetime : String?
    let user_Id : String?
    let user_name : String?
    let user_password : String?
    let user_fname : String?
    let user_lname : String?
    let user_contact : String?
    let user_email : String?
    let user_access_id : String?
    let user_token : String?

    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case notification_title = "notification_title"
        case notification_body = "notification_body"
        case notification_user_id = "notification_user_id"
        case notification_datetime = "notification_datetime"
        case user_Id = "user_Id"
        case user_name = "user_name"
        case user_password = "user_password"
        case user_fname = "user_fname"
        case user_lname = "user_lname"
        case user_contact = "user_contact"
        case user_email = "user_email"
        case user_access_id = "user_access_id"
        case user_token = "user_token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_id = try values.decodeIfPresent(String.self, forKey: .notification_id)
        notification_title = try values.decodeIfPresent(String.self, forKey: .notification_title)
        notification_body = try values.decodeIfPresent(String.self, forKey: .notification_body)
        notification_user_id = try values.decodeIfPresent(String.self, forKey: .notification_user_id)
        notification_datetime = try values.decodeIfPresent(String.self, forKey: .notification_datetime)
        user_Id = try values.decodeIfPresent(String.self, forKey: .user_Id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        user_password = try values.decodeIfPresent(String.self, forKey: .user_password)
        user_fname = try values.decodeIfPresent(String.self, forKey: .user_fname)
        user_lname = try values.decodeIfPresent(String.self, forKey: .user_lname)
        user_contact = try values.decodeIfPresent(String.self, forKey: .user_contact)
        user_email = try values.decodeIfPresent(String.self, forKey: .user_email)
        user_access_id = try values.decodeIfPresent(String.self, forKey: .user_access_id)
        user_token = try values.decodeIfPresent(String.self, forKey: .user_token)
    }

}
