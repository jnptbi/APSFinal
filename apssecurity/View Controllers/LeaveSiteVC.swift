//
//  LeaveSiteVC.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-12-01.
//

import UIKit

class LeaveSiteVC: UIViewController {
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnLeaveSite: UIButton!

    var report_id = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Leave Site"
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
    }
    
    @objc func getTime() {
        let outputFormat = DateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier:"en_US") as Locale
        outputFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        lblDateTime.text = "Date Time: " + outputFormat.string(from: Date())
    }
    
    func currentDate() -> String{
        let outputFormat = DateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier:"en_US") as Locale
        outputFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return outputFormat.string(from: Date())
    }
    
    @IBAction func onClickLeaveSite(_ sender: UIButton) {
        apiCallLeaveSite()
    }
    
    func popToRootViewVC(){
        if let navController = self.navigationController {
            let arrNavControllers = navController.viewControllers
            for vc in arrNavControllers {
                if vc.isKind(of: HomeVC.self) {
                    navController.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func apiCallLeaveSite(){
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)

        let params = [ "report_id": report_id,
                       "time_off":"\(currentDate())"] as [String : Any]
        
        for (key, value) in params {
           print("** ShiftFinish Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: AppURL.timeoff , params: params, model: EndShiftWrapper.self) {
            result in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideProgressView()
                switch result {
                case .success(let response):
                    //print(response)
                    self.popToRootViewVC()
                    print("** LeaveSite Response: \(response)")
                case .failure(let failureResponse):
                    print(failureResponse.message ?? "")
                case .error(let e):
                    print(e ?? "")
                }
            }
        }
    }
}
