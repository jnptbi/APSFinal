//
//  MyTextFields.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct MyTextField: View {
    
    @Binding var txtFieldText: String
    var imageIcon: Image = Image(systemName: "person")
    var placeholderText: String
    
    var body: some View {
        
        HStack(spacing: 15) {
            imageIcon
            
            TextField(placeholderText,
                      text: self.$txtFieldText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white))
        .foregroundColor(Color("clrSecondary"))
        
    }
}

struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField(txtFieldText: .constant("Enter User Name"), placeholderText: "User Name")
    }
}
