//
//  HideNavigationBar.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct HiddenNavigationBar: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
}
