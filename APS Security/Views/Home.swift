//
//  Reporting.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

var menuElements = ["Reporting", "Notifications", "App Info"]

enum ElementType: String, Identifiable, CaseIterable {
    case reporting = "Reporting"
    case notifcations = "Notifications"
    case appInfo = "App Info"
    //case incedentReport = "Incedent Report"
    
    var id : String { UUID().uuidString }
    
    var myId: Int {
        switch self {
        case .reporting:
            return 0
        case .notifcations:
            return 1
        case .appInfo:
            return 2
//        case .incedentReport:
//            return 3
        }
    }
    
    static var menuList: [String] = ElementType.allCases.map({
        $0.rawValue
    })
}

struct Home: View {
    
    @State var showMenu = false
    @State var elementName = ElementType.reporting.rawValue
    @State var isNavigationBarHidden: Bool = true
    
    @ObservedObject var user: User
        
    var body: some View {
        
        //print("--Home Officer name: \(user.loginUserName)")
        
        return GeometryReader { geometry in
            
            VStack(spacing: 0) {
                MyMenuBar(showMenu: self.$showMenu, elementName: self.$elementName)
                .frame(width: geometry.size.width)
                //.offset(x: self.showMenu ? geometry.size.width/2 : 0)
                .offset(x: self.showMenu ? (geometry.size.width*2)/3 : 0)
                .fixedSize(horizontal: false, vertical: true)
                
                ZStack {
                    ReportingView(user: self.user).opacity(self.elementName == ElementType.reporting.rawValue ? 1 : 0)
                        
                    NotificationsView(user: self.user).opacity(self.elementName == ElementType.notifcations.rawValue ? 1 : 0)
                    AppInfo().opacity(self.elementName == ElementType.appInfo.rawValue ? 1 : 0)
                    //IncedentReportView().opacity(self.elementName == ElementType.incedentReport.rawValue ? 1 : 0)
                }
            }
          
            if self.showMenu {
                MySideMenu(showMenu: self.$showMenu, elementName: self.$elementName, element: self.elementName)
                    //.frame(width: geometry.size.width/2)
                    .frame(width: (geometry.size.width*2)/3)
                    .transition(.move(edge: .leading))
            }
        }.edgesIgnoringSafeArea([.bottom,.horizontal])
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
}

