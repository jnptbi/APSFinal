//
//  SideMenuVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit
import SideMenu
import Firebase

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var arrMenuItems: [[String: String]] = [
        ["title" : "Reporting", "imageName": "home"],
        ["title" : "Notifications", "imageName": "notification"],
        ["title" : "App Info", "imageName": "info"]
    ]
    var loginData: LoginData?

    @IBOutlet weak var tblMenuItemsOutlet: UITableView!
    @IBOutlet weak var btnLogoutOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        self.navigationController?.isNavigationBarHidden = true
        
        self.tblMenuItemsOutlet.delegate = self
        self.tblMenuItemsOutlet.dataSource = self
        self.tblMenuItemsOutlet.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        self.dismiss(animated: true) {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userName.rawValue)
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
            Messaging.messaging().unsubscribe(fromTopic: "all")
            
            (self.appDelegate.window?.rootViewController as! UINavigationController).viewControllers.removeAll()
            SideMenuManager.default.leftMenuNavigationController = nil
            (self.appDelegate.window?.rootViewController as! UINavigationController).setViewControllers([], animated: true)
            let objLoginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            (self.appDelegate.window?.rootViewController as! UINavigationController).setViewControllers([objLoginVC], animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.lblMenuItemTitle.text = arrMenuItems[indexPath.row]["title"]
        cell.imageMenuItem.image = UIImage(named: arrMenuItems[indexPath.row]["imageName"] ?? "")

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dismiss(animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let objNotificationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(objNotificationVC, animated: true)
        } else {
            let objEnterSiteVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppInfoVC") as? AppInfoVC
            self.navigationController?.pushViewController(objEnterSiteVC!, animated: true)

        }
    }
}
