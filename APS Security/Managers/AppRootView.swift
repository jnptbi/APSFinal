//
//  AppRootView.swift
//  APS Security
//
//  Created by Vishal Patel on 03/11/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

enum StartScreen {
    case login
    case home
}

class ViewRouter: ObservableObject {
    @Published var currentPage: StartScreen = .login
}

struct AppRootView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var appState: AppState
    @ObservedObject var user = User()
    
    var body: some View {
        
        switch viewRouter.currentPage {
        case .login:
            LoginView(user: user)
        case .home:
            Home(elementName: ElementType.notifcations.rawValue, user: user)
        }
    }
}
