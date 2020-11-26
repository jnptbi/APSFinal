//
//  ContentView.swift
//  APS Security
//
//  Created by Vishal Patel on 17/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var loginUserData: LoginData? = nil
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    
    @ObservedObject var user = User()
    
    @State var isViewActive: Bool = false
    @State var showLoadingIndicator: Bool = false
    
    @ObservedObject var locationManager = LocationManager2()

    var body: some View {
        
        NavigationView {
            
            ZStack {
                    Color("clrSecondary").edgesIgnoringSafeArea(.all)
            
                    GeometryReader { geo in
                        
                        VStack(spacing: 20) {
                            Image("APS_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.4)
                            .padding(.bottom, 30)
                            
                            MyTextField(txtFieldText: self.$username, placeholderText: "Enter Username")
                            
                            MySecureTextField(txtFieldText: self.$password, showPassword: self.$showPassword)
                            
                            NavigationLink(destination: Home(user: self.user), isActive: self.$isViewActive) {
                                
                                Button(action: {
                                    // self.isViewActive = true
                                    //showLoadingIndicator = true
                                    //self.loginAPI()
                                    
                                    //print("Username: \(self.username)")
                                    //print("Password: \(self.password)")
                                    let isLoginValid = self.username != "" && self.password != "" 
                                    
                                    if isLoginValid {
                                        showLoadingIndicator = true
                                        self.loginAPI()
                                    } else {
                                      self.shouldShowLoginAlert = true
                                    }
                                    
                                }) {
                                    Text.init("Login")
                                        .font(.system(size: 25))
                                        .fontWeight(.semibold)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                            .isDetailLink(false)
                            .onReceive(self.appState.$moveToLogin) { moveToLogin in
                                if moveToLogin {
                                    print("MoveToLogin: \(moveToLogin)")
                                    self.isViewActive = false
                                    self.appState.moveToLogin = false
                                }
                            }
                        }
                        
                    }
                    .padding()

                if self.showLoadingIndicator{
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .gradient([.white, .red]))
                        .frame(width: 60.0, height: 60.0)
                }
            }.disabled(self.showLoadingIndicator)
                
            .alert(isPresented: $shouldShowLoginAlert) {
              Alert(title: Text("UserName/Password can't be empty"))
            }
            
        }
        
    }
    
    func loginAPI() {
        let params = ["user_name": self.username,
                      "user_password": self.password] as [String : Any]
    
//        let params = ["user_name":"Smith@Admin",
//        "user_password":"Admin@123"] as [String : Any]
        
        let apiCall = ApiCall()
        apiCall.post(apiUrl: "https://apsreporting.com.au/api/User/loginUser", params: params, model: LoginWrapper.self) { apiResponse in
            showLoadingIndicator = false
            switch apiResponse {
            case .success(let login):
                
                if let userData = login.data.first{
                    self.user.userData = userData
                    self.user.userId = userData.userID
                    self.user.loginUserName = userData.userName
                    
                    UserDefaults.standard.set(userData.userName, forKey: "userName")
                    UserDefaults.standard.set(userData.userID, forKey: "userId")
                    UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    
                }
                print("Login Officer name: \(self.user.loginUserName)")
                self.isViewActive = true
            case .error(let error):
                print("Login error: \(error!.localizedDescription)")
            case .failure(let status):
                print("Failure status: \(status.status ?? Int()) and message: \(status.message ?? String())")
            }
        }
        
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
