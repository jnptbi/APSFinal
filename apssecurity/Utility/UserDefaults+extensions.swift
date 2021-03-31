//
//  UserDefaults+extensions.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 08/11/20.
//

import UIKit
enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
    case userName
    case latitude
    case longitude
    case userAccessID
}

extension UserDefaults {
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    
    
    func isLoggedIn()-> Bool {
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.isLoggedIn.rawValue) {
            return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        } else {
            return false
        }
    }
    
    //MARK: Save User Data
    func setUserID(value: String){
        set(value, forKey: UserDefaultsKeys.userID.rawValue)
    }
    
    //MARK: Retrieve User Data
    func getUserID() -> String{
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.userID.rawValue) {
            return value(forKey: UserDefaultsKeys.userID.rawValue) as! String
        }
        return ""
    }
    
    //MARK: Save User Acces ID
    func setUserAccessID(value: String) {
        set(value, forKey: UserDefaultsKeys.userAccessID.rawValue)
    }
    
    //MARK: Get User Acces ID
    func getUserAccessID() -> String{
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.userAccessID.rawValue) {
            return value(forKey: UserDefaultsKeys.userAccessID.rawValue) as! String
        }
        return ""
    }
    
    //MARK: Save User Name
    func setUserName(value: String){
        set(value, forKey: UserDefaultsKeys.userName.rawValue)
    }
    
    //MARK: Retrieve User Name
    func getUserName() -> String{
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.userName.rawValue) {
            return value(forKey: UserDefaultsKeys.userName.rawValue) as! String
        }
        return ""
    }

}
