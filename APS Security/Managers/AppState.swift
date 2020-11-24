//
//  AppState.swift
//  APS Security
//
//  Created by Vishal Patel on 20/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var moveToLogin: Bool = false
    @Published var moveToReporting: Bool = false
    @Published var moveToEnterSite: Bool = false
    @Published var moveToInspectionDetail: Bool = false
}
