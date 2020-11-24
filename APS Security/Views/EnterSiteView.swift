//
//  EnterSiteView.swift
//  APS Security
//
//  Created by Vishal Patel on 07/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct EnterSiteView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var inspectionDate: String
    @State var toEnterSite : Bool = false
    @State var toEnterSiteFromShiftFinish : Bool = false
    
    @ObservedObject var user: User
    var body: some View {
        
        VStack(spacing: 100) {
            
            NavigationLink(destination: InspectionDetailsView(inspectionDate: inspectionDate, user: self.user), isActive: $toEnterSite) {
                Button(action: {
                    self.toEnterSite = true
                }) {
                    Text.init("Enter Site")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                }
                .buttonStyle(EllipseButtonStyle())
            }
            .isDetailLink(false)
            
            NavigationLink(destination: ShiftFinishDetailsView(user: self.user), isActive: self.$toEnterSiteFromShiftFinish) {
                Button(action: {
                    print("Do nothing")
                    self.toEnterSiteFromShiftFinish = true
                }) {
                    Text.init("Finish Patrol")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                }
                .buttonStyle(CornerButtonStyle())
                //.padding(.top, 100)
                //.padding()
            }
            .isDetailLink(false)
        }
        .navigationBarTitle("Enter Site")
        .onReceive(self.appState.$moveToEnterSite) { moveToEnterSite in
            if moveToEnterSite {
                print("MoveToEnterSite: \(moveToEnterSite)")
                self.toEnterSite = false
                self.toEnterSiteFromShiftFinish = false
                self.appState.moveToEnterSite = false
            }
        }
        
    }
}
/*
 struct EnterSiteView_Previews: PreviewProvider {
 static var previews: some View {
 EnterSiteView(inspectionDate: "07/10/2020 01:00PM"))
 }
 }
 */
