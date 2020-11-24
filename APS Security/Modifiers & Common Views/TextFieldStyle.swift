//
//  TextFieldStyle.swift
//  APS Security
//
//  Created by Vishal Patel on 18/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct AITextField: View {
    
    @Binding var txtFieldText: String
    //var txtFieldVal: String
    var placeholder: Text
    @State var secure: Bool
    @Binding var showPassword: Bool
    var imageIcon: Image = Image(systemName: "person")
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    
    var body: some View {
        
        HStack(spacing: 15) {
            imageIcon
            
            if secure {
                if txtFieldText.isEmpty {
                    placeholder
                }
                SecureField("", text: $txtFieldText, onCommit: commit)
            } else {
                if txtFieldText.isEmpty {
                    placeholder
                }
                TextField("", text: $txtFieldText, onEditingChanged: editingChanged, onCommit: commit)
            }
            
            if secure {
                Button(action: {
                    self.secure.toggle()
                    print("Show/Hide Password")
                }, label: {
                    Image(systemName: "eye")
                })
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white))
        .foregroundColor(Color("clrSecondary"))
        
    }
    
}

struct AITextField_Previews: PreviewProvider {
    static var previews: some View {
        AITextField(txtFieldText: .constant("UserName"), placeholder: Text("User name"), secure: false, showPassword: .constant(false))
    }
}


