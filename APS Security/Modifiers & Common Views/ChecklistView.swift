//
//  ChecklistView.swift
//  APS Security
//
//  Created by Vishal Patel on 28/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct ChecklistView: View {
    
    @Binding var isChecked:Bool
    var title:String
    //var count:Int = 0
    func toggle(){isChecked = !isChecked}
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 18, height: 18)
            }
            Text(title)
                .font(.system(size: 18))
            
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(isChecked: .constant(true), title: "This is checklist")
    }
}
