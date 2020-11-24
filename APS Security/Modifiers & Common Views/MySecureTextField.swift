//
//  MySecureTextField.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct MySecureTextField: View {
    
    @Binding var txtFieldText: String
    @Binding var showPassword: Bool
    
    var body: some View {
        
        HStack(spacing: 15) {
            Image(systemName: "lock")
            
            if showPassword {
                TextField("Enter Password",
                text: self.$txtFieldText)
            } else {
                SecureField("Enter Password", text: self.$txtFieldText)
            }
            
            Button(action: {
                self.showPassword.toggle()
                //print("Show/Hide Password")
            }, label: {
                Image(systemName: "eye")
            })
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white))
        .foregroundColor(Color("clrSecondary"))
        
    }
    
}

struct MySecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        MySecureTextField(txtFieldText: .constant("Enter Password"), showPassword: .constant(true))
    }
}
