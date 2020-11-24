//
//  TestNotificationView.swift
//  APS Security
//
//  Created by Vishal Patel on 08/11/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct TestNotificationView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TestNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        TestNotificationView()
    }
}

/*
 
 struct NotificationRow: View {
     
     var title: String
     var dateStr: String
     var message: String
     
     let dateFormatter = DateFormatter()
     let calendar = Calendar.current
     
     var numOfHours: String {
         let date = dateFormatter.date(from: dateStr)!
         let components = calendar.dateComponents([.day, .hour, .minute], from: date)
         let hours = components.hour
         let days = components.day
         let minute = components.minute
         
         var str = ""
         if days != 0 {
             str = String(days!) + " days - "
         }
         if hours != 0 {
             str += String(hours!) + " hours before"
         } else {
             str += String(minute!) + " minutes before"
         }
         
         return str
     }
     
     var body: some View {
         
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         
         return VStack {
             Text(title)
                 .font(.system(size: 23))
             
             Text(dateStr)
                 .font(.system(size: 18))
             
             Text(message)
                 .font(.system(size: 20))
         }
         //.padding()
     }
 }

 struct SendNotificationWrapper: Codable {
     let status: Int
     let Message: String
 }


 struct NotificationsView: View {
     
     @State private var notificationList = [NotificationData]()
     @EnvironmentObject var appState: AppState
     
     @ObservedObject var user: User
     
     @State private var details = ""
     @State var showLoadingIndicator: Bool = false
     var sendIcon: Image = Image(systemName: "paperplane.fill")
     
     @ObservedObject private var keyboard = KeyboardResponder()

     @State private var shouldShowLoginAlert: Bool = false
     
     var body: some View {
         
         GeometryReader { geo in
             VStack {
                 List{
                     ForEach(notificationList, id: \.self) { noti in
                         let title = noti.notification_title!
                         let time = noti.notification_datetime!
                         let message = noti.notification_body!
                         
                         NotificationRow(title: title, dateStr: time, message: message)
                             .frame(width: geo.size.width - 60)
                         
                     }
                     .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))
                 }
                 
                 HStack(alignment: .center) {
                     MultilineTextField("Enter details", text: self.$details, onCommit: {
                         print("Final comments: \(self.details)")
                     })
                     
                     sendIcon
                         .onTapGesture {
                             self.sendNotification()
                         }
                 }
                 .padding(.horizontal, 40)
                 
                 Spacer()
                     .frame(height: 20)
                     .fixedSize(horizontal: false, vertical: true)
                 
             }
         }
         .padding(.bottom, keyboard.currentHeight)
         .animation(.spring())
         .onAppear {
             self.getNotificationList()
         }
         .alert(isPresented: $shouldShowLoginAlert) {
           Alert(title: Text("Notification send successfully!!!"))
         }
         
     }
     
     func getNotificationList() {
         //self.Loading = true
         let url = URL(string: "https://apsreporting.com.au/api/User/notifications")!
         var request = URLRequest(url: url)
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "GET"
         URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {
                 print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                 return
             }
             print("get notificationList: \(response)")
             
             DispatchQueue.main.async {
                 if let notificationData = try? JSONDecoder().decode(NotificationWrapper.self, from: data) {
                     
                     self.notificationList = notificationData.data!
                     //self.Loading = false
                     print("====\(self.notificationList)")
                 } else {
                     print("Invalid response from server")
                 }
             }
         }.resume()
     }
     
     func sendNotification() {
         
         let userName: String = UserDefaults.standard.value(forKey: "userName") as! String
         let userId: String = UserDefaults.standard.value(forKey: "userId") as! String
         /*
         let params = ["title": userName,
                       "body_message": self.details,
                       "user_id": userId] as [String : Any]
         
         
          let params = ["title": "hellpo",
                       "body_message": "asdasdasd",
                       "user_id": "1"] as [String : Any]
          */
         
         let params = ["title": userName,
                       "message_body": self.details,
                       "user_id": userId] as [String : Any]
         
         for (key, value) in params {
            print("** Reporting Key:(\(key),Value: \(value))")
         }
         
         let apiCall = ApiCall()
         apiCall.post(apiUrl: "https://apsreporting.com.au/api/User/sendNotification", params: params, model: SendNotificationWrapper.self) { apiResponse in
             showLoadingIndicator = false
             switch apiResponse {
             case .success(let response):
                 self.shouldShowLoginAlert = true
                 print("Notification Officer name: \(response.Message)")
                 getNotificationList()
                 self.details = ""
             case .error(let error):
                 print("Notification error: \(error!.localizedDescription)")
             case .failure(let status):
                 print("Notification status: \(status.status ?? Int()) and message: \(status.message ?? String())")
             }
         }
         
     }
     
 }
 
*/
