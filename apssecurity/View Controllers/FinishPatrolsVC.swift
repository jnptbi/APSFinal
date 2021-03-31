//
//  FinishPatrolsVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit
import CoreLocation
import Firebase

class FinishPatrolsVC: UIViewController,CLLocationManagerDelegate {
    
    // MARK -
    // MARK: - OUTLETS
    
    @IBOutlet weak var objScrollView: UIScrollView!
    
    @IBOutlet weak var objParentView: UIView!
    
    @IBOutlet weak var tblFinishData: UITableView!
    @IBOutlet weak var txtFinishKm: UITextField!
    @IBOutlet weak var tblCompletionChecklist: UITableView!
    @IBOutlet weak var txtComments: UITextField!
    @IBOutlet weak var btnAddPhotos: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var btnConcludeShift: UIButton!
    
    @IBOutlet weak var cvPhotosHeight: NSLayoutConstraint!
    
    // MARK -
    // MARK: - VARIABLES
    
    let checkListArray = ["I have completed my shift as per the allocated roaster schedule",
                          "All details provided are true & correct",
                          "I can confirm no damage to the work car inside & outside",
                          "I can confirm the work car to be clean condition inside & outside",
                          "I can confirm the work car inspected properly & is in safe condition",
                          "I can confirm having full uniform throughout my shift",
                          "I can confirm no damage to the allocated equipment"]
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var latitude = 0.0
    var longitude = 0.0
    var loginData: LoginData?
    
    var arrVehicleUnitList: [vehicleUnitList] = []
    var selectedVehicleUnit = ""
    var selVehicleUnitNumID = ""
    
    var arrVehiclePatrolArea: [vehiclePatrolArea] = []
    var selectedPatrolArea = ""
    var selPetrolAreaID = ""
    
    var currentDateAndTime = ""
    let formatter = DateFormatter()
    
    var imagePicker: ImagePicker!
    var arrImageData = [ImageData]()
    var arrSelectedImageIDs : [Int] = []
    
    var comments = ""
    var finishKm = ""
    var address = "Not Found"
    
    var userData: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Shift Finish Details"
        
        if userData != nil {
            self.loginData = userData!.userData
            self.arrVehicleUnitList = userData!.arrVehicleUnitList
            self.selectedVehicleUnit = userData!.selectedVehicleUnit
            self.selVehicleUnitNumID = userData!.selVehicleUnitNumID
            self.arrVehiclePatrolArea = userData!.arrVehiclePetrolArea
            self.selectedPatrolArea = userData!.selectedPatrolArea
            self.selPetrolAreaID = userData!.selPetrolAreaID
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locationManager.location
            if currentLocation != nil {
                self.latitude = currentLocation.coordinate.latitude
                self.longitude = currentLocation.coordinate.longitude
            }
        }
        self.getAddressFromLatLon(pdblLatitude: self.latitude, withLongitude: self.longitude)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentDateAndTime = formatter.string(from: Date())
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        if self.arrImageData.count <= 0 {self.cvPhotosHeight.constant = 0}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
    
    // MARK -
    // MARK: - IBActions
    
    @IBAction func onClickAddPhotoBtn(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func onClickFinishPatrolsBtn(_ sender: UIButton) {
        self.apiCallShiftFinish()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    currentLocation = manager.location
                    if currentLocation != nil {
                        self.latitude = currentLocation.coordinate.latitude
                        self.longitude = currentLocation.coordinate.longitude
                        self.getAddressFromLatLon(pdblLatitude: self.latitude, withLongitude: self.longitude)
                    }
                }
            }
        }
    }

}

extension FinishPatrolsVC: ImagePickerDelegate {

    func didSelect(image: UIImage?, path: String?) {
        guard let img = image else {
            return
        }
        guard let path = path else {
            return
        }
        
        self.apiCallShiftFinishUploadImage(path: path, img: img)
        
//        let tempDict = ImageData(path: path, image: img)
//        self.arrImageData.append(tempDict)
//        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.cvPhotos.reloadData()
//        }
    }
}

// MARK -
// MARK: - Table Delegates
// MARK:-

extension FinishPatrolsVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblFinishData {
            return 5
        } else {
            return checkListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblFinishData {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportingDataCell", for: indexPath) as? ReportingDataCell else {
                return UITableViewCell()
            }
            cell.setData(indexPath: indexPath, name: UserDefaults.standard.getUserName() , area: selectedPatrolArea, shiftTime: currentDateAndTime, vehicleUnit: selectedVehicleUnit, address: address, vc: self)
            return cell;
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportingChecklistCell", for: indexPath) as? ReportingChecklistCell else {
                return UITableViewCell()
            }
            cell.checklistTitle.text = checkListArray[indexPath.row]
            cell.accessoryType = .none
            return cell;
        }
    }
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblFinishData {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblFinishData {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tblFinishData {
            if indexPath.row == 1 || indexPath.row == 3 {
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatrolAreaAndVehicleUnitDetailVC") as? PatrolAreaAndVehicleUnitDetailVC
//                if indexPath.row == 1 {
//                    vc?.isForPatrolArea = true
//                    vc?.finishPatrolVC = self
//                    vc?.arrVehiclePatrolArea = self.arrVehiclePatrolArea
//                } else if indexPath.row == 3 {
//                    vc?.isForPatrolArea = false
//                    vc?.finishPatrolVC = self
//                    vc?.arrVehicleUnitList = self.arrVehicleUnitList
//                }
//                self.navigationController?.pushViewController(vc!, animated: true)
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? ReportingChecklistCell {
                cell.btnChecklist.isSelected = !cell.btnChecklist.isSelected
            }
        }
    }
}

// MARK -
// MARK: - CollectionView Delegates
// MARK:-

extension FinishPatrolsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportingPhotoCollectionCell", for: indexPath) as? ReportingPhotoCollectionCell else {
            return UICollectionViewCell()
        }
        cell.objImgView.image = self.arrImageData[indexPath.row].image
        cell.objDeleteBtn.tag = indexPath.row
        cell.delegate = self
        return cell;
    }
    
    // MARK: - Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

}

extension FinishPatrolsVC: DeleteImageProtocol {
    func deleteImage(index: Int) {
        self.arrImageData.remove(at: index)
        self.cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
}


extension FinishPatrolsVC {
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        if pdblLatitude == 0.0 || pdblLongitude == 0 {return}
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            print(pm.country ?? "")
                                            print(pm.locality ?? "")
                                            print(pm.subLocality ?? "")
                                            print(pm.thoroughfare ?? "")
                                            print(pm.postalCode ?? "")
                                            print(pm.subThoroughfare ?? "")
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            
                                            self.address = addressString
                                            print(addressString)
                                            self.tblFinishData.reloadData()
                                        }
                                    })
        
    }
    
    
    func apiCallShiftFinishUploadImage(path: String,img: UIImage){
        
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        
        let arrFiles = [
            [MultiPart.fieldName: "file",
             MultiPart.pathURLs: [path]]
        ]
        
        //https://apsreporting.com.au/api/User/insert_file  //single File
        //https://apsreporting.com.au/api/User/upload  // Multiple
        // With Model Object
        MultiPart().callPostWSWithModel(AppURL.insert_file , parameters: nil, filePathArr: arrFiles, model: InsertFileWrapper.self) {
            result in
            ActivityIndicator.shared.hideProgressView()
            switch result {
            case .success(let response):
                print(response)
                if response.data != nil {
                   if let data = response as? InsertFileWrapper {
                    for item in data.data {
                        let tempDict = ImageData(path: path, image: img, imageId: item.image_id)
                        self.arrImageData.append(tempDict)
                        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
                            self.cvPhotos.reloadData()
                        }
                    }
                }
            case .failure(let failureResponse):
                print(failureResponse.message ?? "")
            case .error(let e):
                print(e ?? "")
            }
        }
    }
    
    func resetChecks() -> [String] {
        var arrChecklist = [String]()
        for i in 0..<self.tblCompletionChecklist.numberOfRows(inSection: 0) {
            if let cell = self.tblCompletionChecklist.cellForRow(at: IndexPath(row: i, section: 0)) as? ReportingChecklistCell {
                if cell.btnChecklist.isSelected {
                    arrChecklist.append("true")
                } else {
                    arrChecklist.append("false")
                }
            }
        }
        return arrChecklist
    }
    
    func apiCallShiftFinish(){
        if userData == nil {return}
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)

        arrSelectedImageIDs.removeAll()
        for item in arrImageData{
            arrSelectedImageIDs.append(Int(item.imageId!)!)
        }
        
        let arrCheckList = resetChecks()
        finishKm = self.txtFinishKm.text ?? ""
        comments = self.txtComments.text ?? ""
        
        let params = [ "shift_id": self.userData!.shiftId,
                       "fc_finish_cl_1":"\(arrCheckList[0])",
                       "fc_finish_cl_2":"\(arrCheckList[1])",
                       "fc_finish_cl_3":"\(arrCheckList[2])",
                       "fc_finish_cl_4":"\(arrCheckList[3])",
                       "fc_finish_cl_5":"\(arrCheckList[4])",
                       "fc_finish_cl_6":"\(arrCheckList[5])",
                       "fc_finish_cl_7":"\(arrCheckList[6])",
                       "latitude":latitude,
                       "longitude":longitude,
                       "fulladdress":address,
                       "shift_finish_km":"\(finishKm)",
                       "shift_finish_time":currentDateAndTime,
                       "shift_finish_comments":"\(comments)",
                       "shift_end_img_id":arrSelectedImageIDs] as [String : Any]
        
        for (key, value) in params {
           print("** ShiftFinish Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: AppURL.endShift , params: params, model: EndShiftWrapper.self) {
            result in
            
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideProgressView()
                switch result {
                case .success(let response):
                    self.arrImageData.removeAll()
                    self.arrSelectedImageIDs.removeAll()

                        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID.rawValue)
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userName.rawValue)
                        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                        Messaging.messaging().unsubscribe(fromTopic: "all")
                        
                        (self.appDelegate.window?.rootViewController as! UINavigationController).viewControllers.removeAll()
                        (self.appDelegate.window?.rootViewController as! UINavigationController).setViewControllers([], animated: true)
                        let objLoginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        (self.appDelegate.window?.rootViewController as! UINavigationController).setViewControllers([objLoginVC], animated: true)
                    //print(response)
//                    if let navController = self.navigationController {
//                        let arrNavControllers = navController.viewControllers
//                        for vc in arrNavControllers {
//                            if vc.isKind(of: ReportingVC.self) {
//                                navController.popToViewController(vc, animated: true)
//                                return
//                            }
//                        }
//                    }
                    
                    print("** ShiftFinish Response: \(response)")
                case .failure(let failureResponse):
                    print(failureResponse.message ?? "")
                case .error(let e):
                    print(e ?? "")
                }
            }
        }
    }
}
