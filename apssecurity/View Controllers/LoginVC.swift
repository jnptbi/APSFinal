//
//  LoginVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit
import CoreLocation
import Firebase

class LoginVC: UIViewController , CLLocationManagerDelegate{
    var locationManager: CLLocationManager?

//    var user = User()
    var isPasswordVisible: Bool = false
    
    @IBOutlet weak var txtUsernameOutlet: UITextField!
    @IBOutlet weak var txtPasswordOutlet: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var btnPasswordEyeOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
//        self.txtUsernameOutlet.text = "Admin@Techbiz"
//        self.txtPasswordOutlet.text = "Techbiz@14"
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPasswordEyeAction(_ sender: UIButton) {
        if isPasswordVisible {
            self.isPasswordVisible = false
            self.txtPasswordOutlet.isSecureTextEntry = true
            self.btnPasswordEyeOutlet.setImage(#imageLiteral(resourceName: "eye_open"), for: .normal)
        } else {
            self.isPasswordVisible = true
            self.txtPasswordOutlet.isSecureTextEntry = false
            self.btnPasswordEyeOutlet.setImage(#imageLiteral(resourceName: "eye_close"), for: .normal)
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if self.txtUsernameOutlet.text == "" {
            self.showToast(message: "Username cannot be empty")
        } else if self.txtPasswordOutlet.text == "" {
            self.showToast(message: "Password cannot be empty")
        } else {
            self.loginAPI()
        }
    }
    
    // MARK: - API Call Methods

    func loginAPI() {
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)

        let params = ["user_name": self.txtUsernameOutlet.text!,
                      "user_password": self.txtPasswordOutlet.text!] as [String : Any]

        let apiCall = ApiCall()
        apiCall.post(apiUrl: AppURL.LoginUrl, params: params, model: LoginWrapper.self) { apiResponse in
            ActivityIndicator.shared.hideProgressView()
            switch apiResponse {
            case .success(let login):
//                self.user.loginUserName = login.data.first!.userName
                if login.data.first != nil{
                    UserDefaults.standard.setLoggedIn(value: true)
                    UserDefaults.standard.setUserID(value: login.data.first!.userID)
                    UserDefaults.standard.setUserName(value: login.data.first!.userName)
                    UserDefaults.standard.setUserAccessID(value: login.data.first!.userAccessID)
//                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = redViewController
                    
                    Messaging.messaging().subscribe(toTopic: "all")

                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportingVC") as? ReportingVC
                    vc?.loginData = login.data.first
                    self.navigationController?.pushViewController(vc!, animated: true)

//                    self.user.userData = userData
                }
//                print("Login Officer name: \(self.user.loginUserName)")
            case .error(let error):
                UserDefaults.standard.setLoggedIn(value: false)
                print("Login error: \(error!.localizedDescription)")
            case .failure(let status):
                UserDefaults.standard.setLoggedIn(value: false)
                print("Failure status: \(status.status ?? Int()) and message: \(status.message ?? String())")
            }
        }
    }
}
