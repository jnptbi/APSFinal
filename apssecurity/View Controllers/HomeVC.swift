//
//  HomeVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit
import CoreLocation
import SideMenu

class HomeVC: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!

    @IBOutlet weak var btnEnterSiteOutlet: UIButton!
    @IBOutlet weak var btnFinishPatrolsOutlet: UIButton!
    
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  setUpNavigationBar()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.title = "Enter Site"
        // Do any additional setup after loading the view.
    }
   /*
    func setUpNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "menu"), for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(HomeVC.openCloseMenu(sender:)), for:.touchUpInside)

        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = rightBarButton
    }
    @objc func openCloseMenu(sender: UIButton) {
        let objSideMenuVC = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC)!
        let menu = SideMenuNavigationController(rootViewController: objSideMenuVC)
        menu.leftSide = true
        menu.menuWidth = 300
        present(menu, animated: true, completion: nil)
    }
    */
    @IBAction func btnEnterSiteAction(_ sender: UIButton) {
        let objEnterSiteVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterSiteVC") as? EnterSiteVC
        objEnterSiteVC?.userData = userData
        self.navigationController?.pushViewController(objEnterSiteVC!, animated: true)
    }
    
    @IBAction func btnFinishPatrolsAction(_ sender: UIButton) {
        let objFinishPatrolsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FinishPatrolsVC") as? FinishPatrolsVC
        objFinishPatrolsVC?.userData = userData
        self.navigationController?.pushViewController(objFinishPatrolsVC!, animated: true)
    }
}
