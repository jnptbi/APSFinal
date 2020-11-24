//
//  ExtView.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

extension View {
 
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

