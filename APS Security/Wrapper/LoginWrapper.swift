//
//  LoginWrapper.swift
//  APS Security
//
//  Created by Vishal Patel on 06/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

struct LoginWrapper: Codable {
    let status: Int
    let message: String
    let data: [LoginData]
}

struct LoginData: Codable {
    
    var userID = ""
    var userName = ""
    var userPassword = ""
    var userFname = ""
    var userLname = ""
    var userContact = ""
    var userEmail = ""
    var userAccessID = ""
    var userToken = ""

    enum CodingKeys: String, CodingKey {
        case userID = "user_Id"
        case userName = "user_name"
        case userPassword = "user_password"
        case userFname = "user_fname"
        case userLname = "user_lname"
        case userContact = "user_contact"
        case userEmail = "user_email"
        case userAccessID = "user_access_id"
        case userToken = "user_token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let userID = try? container.decode(String.self, forKey: .userID){
            self.userID = userID
        }
        if let userName = try? container.decode(String.self, forKey: .userName){
            self.userName = userName
        }
        if let userPassword = try? container.decode(String.self, forKey: .userPassword){
            self.userPassword = userPassword
        }
        if let userFname = try? container.decode(String.self, forKey: .userFname){
            self.userFname = userFname
        }
        if let userLname = try? container.decode(String.self, forKey: .userLname){
            self.userLname = userLname
        }
        if let userContact = try? container.decode(String.self, forKey: .userContact){
            self.userContact = userContact
        }
        if let userEmail = try? container.decode(String.self, forKey: .userEmail){
            self.userEmail = userEmail
        }
        if let userAccessID = try? container.decode(String.self, forKey: .userAccessID){
            self.userAccessID = userAccessID
        }
        if let userToken = try? container.decode(String.self, forKey: .userToken){
            self.userToken = userToken
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(userName, forKey: .userName)
        try container.encode(userPassword, forKey: .userPassword)
        try container.encode(userFname, forKey: .userFname)
        try container.encode(userLname, forKey: .userLname)
        try container.encode(userContact, forKey: .userContact)
        try container.encode(userEmail, forKey: .userEmail)
        try container.encode(userAccessID, forKey: .userAccessID)
        try container.encode(userToken, forKey: .userToken)
    }
}
