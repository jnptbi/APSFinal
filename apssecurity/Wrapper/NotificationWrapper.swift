//
//  NotificationWrapper.swift
//  APS Security
//
//  Created by Vishal Patel on 03/11/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

struct NotificationWrapper : Codable {
    let status : Int
    let message : String
    let data : [NotificationData]
}

struct SendNotificationWrapper: Codable {
    let status: Int
    let Message: String
}


struct NotificationData : Codable {
    
    var notification_id : String = ""
    var notification_title : String = ""
    var notification_body : String = ""
    var notification_user_id : String = ""
    var notification_datetime : String = ""
    var user_Id : String = ""
    var user_name : String = ""
    var user_password : String = ""
    var user_fname : String = ""
    var user_lname : String = ""
    var user_contact : String = ""
    var user_email : String = ""
    var user_access_id : String = ""
    var user_token : String = ""

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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let notification_id = try? container.decode(String.self, forKey: .notification_id){
            self.notification_id = notification_id
        }
        if let notification_title = try? container.decode(String.self, forKey: .notification_title){
            self.notification_title = notification_title
        }
        if let notification_body = try? container.decode(String.self, forKey: .notification_body){
            self.notification_body = notification_body
        }
        if let notification_user_id = try? container.decode(String.self, forKey: .notification_user_id){
            self.notification_user_id = notification_user_id
        }
        if let notification_datetime = try? container.decode(String.self, forKey: .notification_datetime){
            self.notification_datetime = notification_datetime
        }
        if let user_Id = try? container.decode(String.self, forKey: .user_Id){
            self.user_Id = user_Id
        }
        if let user_name = try? container.decode(String.self, forKey: .user_name){
            self.user_name = user_name
        }
        if let user_password = try? container.decode(String.self, forKey: .user_password){
            self.user_password = user_password
        }
        if let user_fname = try? container.decode(String.self, forKey: .user_fname){
            self.user_fname = user_fname
        }
        if let user_lname = try? container.decode(String.self, forKey: .user_lname){
            self.user_lname = user_lname
        }
        if let user_contact = try? container.decode(String.self, forKey: .user_contact){
            self.user_contact = user_contact
        }
        if let user_email = try? container.decode(String.self, forKey: .user_email){
            self.user_email = user_email
        }
        if let user_access_id = try? container.decode(String.self, forKey: .user_access_id){
            self.user_access_id = user_access_id
        }
        if let user_token = try? container.decode(String.self, forKey: .user_token){
            self.user_token = user_token
        }
    }

}
