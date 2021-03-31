//
//  NotificationVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblNotificationList: UITableView!
    
    @IBOutlet weak var txtDetail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var viewSendMessageHeight: NSLayoutConstraint!

    var notificationList = [NotificationData]()
    var loginData: LoginData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.getUserAccessID() == "2" {
            self.btnSend.isHidden = true
            self.txtDetail.isHidden = true
            self.viewSendMessageHeight.constant = 0
        }else{
            self.btnSend.isHidden = false
            self.txtDetail.isHidden = false
            self.viewSendMessageHeight.constant = 80
        }
        self.title = "Notifications"
        
        self.tblNotificationList.delegate = self
        self.tblNotificationList.dataSource = self
        
        // Do any additional setup after loading the view.
        self.getNotificationList()
    }
    
    @IBAction func onClickSendBtn(_ sender: UIButton) {
        sendNotification()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.lblNotificationTitleOutlet.text = notificationList[indexPath.row].notification_title
        cell.lblNotificationTimeOutlet.text = self.utcToLocal(dateStr: notificationList[indexPath.row].notification_datetime)
        cell.lblNotificationMessageOutlet.text = notificationList[indexPath.row].notification_body
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

extension NotificationVC {
    
    func getNotificationList() {
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        let url = URL(string: AppURL.notifications )!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            print("get notificationList: \(String(describing: response))")
            ActivityIndicator.shared.hideProgressView()
            DispatchQueue.main.async {
                if let notificationData = try? JSONDecoder().decode(NotificationWrapper.self, from: data) {
                    
                    self.notificationList = notificationData.data
                    self.tblNotificationList.reloadData()
                    self.scrollToBottom()
                    //self.tblNotificationList.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
                    print("====\(self.notificationList)")
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.notificationList.count > 0{
                let indexPath = IndexPath(row: self.notificationList.count-1, section: 0)
                self.tblNotificationList.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func sendNotification() {
        if self.txtDetail.text == "" {return}
        if self.txtDetail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {return}
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        
        let userName: String = UserDefaults.standard.getUserName()
        let userId: String = UserDefaults.standard.getUserID()
        
        let params = ["title": userName,
                      "message_body": self.txtDetail.text ?? "",
                      "user_id": userId] as [String : Any]
        
        for (key, value) in params {
           print("** Reporting Key:(\(key),Value: \(value))")
        }
        
        let apiCall = ApiCall()
        apiCall.post(apiUrl: AppURL.sendNotification , params: params, model: SendNotificationWrapper.self) { apiResponse in
            ActivityIndicator.shared.hideProgressView()
            switch apiResponse {
            case .success(let response):
                self.showAlert(message: "", title: "Notification send successfully!!!", OKActionText: "OK")
                print("Notification Officer name: \(response.Message)")
                self.getNotificationList()
                self.txtDetail.text = ""
            case .error(let error):
                print("Notification error: \(error!.localizedDescription)")
            case .failure(let status):
                print("Notification status: \(status.status ?? Int()) and message: \(status.message ?? String())")
            }
        }
        
    }
    
}
