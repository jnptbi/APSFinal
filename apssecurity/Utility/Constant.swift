//
//  Constant.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit

class Constant: NSObject {
    
}

struct AppURL{
    static let mainURL = "https://apsreporting.com.au/api/User/"
    static let LoginUrl = mainURL + "loginUser"
    static let vehicle_unit = mainURL + "vehicle_unit"
    static let patrol_area = mainURL + "patrol_area"
    static let shiftStart = mainURL + "shiftStart"
    static let drops_data = mainURL + "drops_data"
    static let insert_file = mainURL + "insert_file"
    static let siteReport = mainURL + "siteReport"
    static let timeoff = mainURL + "timeoff"
    static let endShift = mainURL + "endShift"
    static let notifications = mainURL + "notifications"
    static let sendNotification = mainURL + "sendNotification"
}

