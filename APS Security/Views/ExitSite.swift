//
//  ExitSite.swift
//  APS Security
//
//  Created by Vishal Patel on 08/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

class TimerHolder : ObservableObject {
    var timer : Timer!
    @Published var newDate = ""
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.newDate = formatter.string(from: Date())
    }
    func start() {
        self.timer?.invalidate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            self.newDate = formatter.string(from: Date())
        }
    }
}

struct ExitSite: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var updatedDate = TimerHolder()
    
    var body: some View {
        
        return VStack(spacing: 50) {
            
            HStack {
                /*
                 Text("Date Time: \(dateString)")
                 .font(.system(size: 23))
                 .foregroundColor(Color.gray)
                 */
                
                Text("Date Time: \(updatedDate.newDate)")
                    .font(.system(size: 23))
                    .foregroundColor(Color.gray)
                
            }
            
            Button(action: {
                self.appState.moveToEnterSite = true
                print("Leave Site")
            }) {
                Text.init("Leave Site")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
            }
            .buttonStyle(EllipseButtonStyle())
        }
        .navigationBarTitle("Leave Site")
        .onAppear {
            self.updatedDate.start()
        }
        
    }
}
