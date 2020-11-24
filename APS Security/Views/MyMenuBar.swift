//
//  MyMenuBar.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct MyMenuBar: View {
    
    @Binding var showMenu: Bool
    @Binding var elementName: String
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.white//.edgesIgnoringSafeArea(.all)
            
            // Create menu bar
            ZStack {
                
                HStack {
                    Button(action: {
                        print("SideMenu Button Clicked")
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                        .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Text(elementName)
                    .font(.title)
                    //.fontWeight(.semibold)
                    .foregroundColor(Color.black)
            
            }
            .background(Color("clrPrimary"))
        }
        .preferredColorScheme(.light)
    }
}

struct MyMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MyMenuBar(showMenu: .constant(true), elementName: .constant("Home"))
    }
}
