//
//  SideMenu.swift
//  APS Security
//
//  Created by Vishal Patel on 19/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct MySideMenu: View {
    
    @EnvironmentObject var appState: AppState
    
    @Binding var showMenu: Bool
    @Binding var elementName: String
    @State var element: String
        
    var body: some View {

        let clr1 = Color.black.opacity(0.3)
        
        return ZStack(alignment: .trailing) {
            Color("clrPrimary")
            
            VStack {
                
                VStack(alignment: .leading) {
                    Spacer()
                    .frame(height: 30)
                    
                    HStack {
                        Spacer()
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    /*
                    ForEach(menuElements, id: \.self) { element in
                        
                        VStack(alignment: .leading) {
                            
                            Button(action: {
                                //print("Btn pressed")
                                
                                withAnimation {
                                    self.showMenu.toggle()
                                    self.elementName = element
                                    //print("Selected Element: \(element)")
                                }
                            }) {
                                HStack {
                                    Rectangle()
                                        .frame(width: 10, height: 2, alignment: .center)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    
                                    Text(element)
                                        .font(.system(size: 20))
                                        //.fontWeight(.medium)
                                        .foregroundColor(Color.black)
                                }
                                .padding(.horizontal, 20)
                            }
                            Divider().background(Color.black.opacity(0.8))
                        }
                        .padding(.top, 10)
                        //.padding(.bottom, 0)
                        //.background(Color.red)
                    }
                    */
                        
                    ForEach(ElementType.menuList, id: \.self) { element in
                        
                        VStack(alignment: .leading) {
                            
                            Button(action: {
                                //print("Btn pressed")
                                
                                withAnimation {
                                    self.showMenu.toggle()
                                    self.elementName = element
                                    //print("Selected Element: \(element)")
                                }
                            }) {
                                HStack {
                                    Rectangle()
                                        .frame(width: 10, height: 2, alignment: .center)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    
                                    Text(element)
                                        .font(.system(size: 20))
                                        //.fontWeight(.medium)
                                        .foregroundColor(Color.black)
                                }
                                .padding(.horizontal, 20)
                            }
                            Divider().background(Color.black.opacity(0.8))
                        }
                        .padding(.top, 10)
                        //.padding(.bottom, 0)
                        //.background(Color.red)
                    }
                    //.background(Color.black.opacity(0.1))
                    .background(self.elementName == element ? Color.black.opacity(0.1) : .clear)
                    
                    Spacer()
                    //.frame(height: 100)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            print("Logout button clicked")
                            
                            UserDefaults.standard.removeObject(forKey: "userName")
                            UserDefaults.standard.removeObject(forKey: "userId")
                            UserDefaults.standard.set(false, forKey: "userLoggedIn")
                            self.appState.moveToLogin = true
                        }) {
                            Text.init("Logout")
                                .font(.system(size: 22))
                                .padding(.horizontal, 20)
                        }
                        //.buttonStyle(MyButtonStyle())
                        .buttonStyle(LogoutBtnStyle())
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    //Spacer()
                }
                //.padding()
                .padding(.vertical, 20)
                .padding(.trailing, 20)
            }
            Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [clr1,.black]), startPoint: .topLeading, endPoint: .bottomTrailing)).opacity(0.5)
            .frame(width: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct MySideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MySideMenu(showMenu: .constant(true), elementName: .constant(ElementType.menuList[1]), element: ElementType.menuList[1])
    }
}

