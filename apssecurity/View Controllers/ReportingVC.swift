// 
//  ReportingVC.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-11-23.
//

//  

import UIKit
import SideMenu
import CoreLocation

struct ImageData {
    var path = ""
    var image: UIImage?
    var imageId: String?
}

struct User {
    
    var loginUserName = ""
    var shiftId = 0
    var time = ""
    var userId = "0"
    var userData:LoginData?
    var petrolId = "0"
    var arrVehicleUnitList: [vehicleUnitList] = []
    var arrVehiclePetrolArea: [vehiclePatrolArea] = []
    var address = "Not Found"
    var latitude = ""
    var longitude = ""
    
    var selectedVehicleUnit = ""
    var selVehicleUnitNumID = ""
    
    var selectedPatrolArea = ""
    var selPetrolAreaID = ""
    
}

class ReportingVC: UIViewController,CLLocationManagerDelegate {

    // MARK -
    // MARK: - OUTLETS
    
    @IBOutlet weak var objScrollView: UIScrollView!
    
    @IBOutlet weak var objParentView: UIView!
    
    @IBOutlet weak var tblReportingData: UITableView!
    @IBOutlet weak var txtStartKm: UITextField!
    @IBOutlet weak var tblReportingChecklist: UITableView!
    @IBOutlet weak var txtComments: UITextField!
    @IBOutlet weak var btnAddPhotos: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var btnCommencePatrols: UIButton!
    
    @IBOutlet weak var tblReportingDataHeight: NSLayoutConstraint!
    @IBOutlet weak var tblReportingChecklistHeight: NSLayoutConstraint!
    @IBOutlet weak var cvPhotosHeight: NSLayoutConstraint!
    
    // MARK -
    // MARK: - VARIABLES
    
    let checkListArray = ["Attended 15 minutes prior to the shift",
                          "Full Uniform On",
                          "All allocated equipment checked & working fine",
                          "Car is clean condition inside & outside",
                          "Car not damaged inside & outside"]
    
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
    var startKm = ""
    var address = "Not Found"
    var isNotification = false

    // MARK -
    // MARK: - VIEW - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNotification{
            let objNotificationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(objNotificationVC, animated: true)
        }
        setUpNavigationBar()
        self.getPatrolAreaApi()
        self.getVehicleUnitApi()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = locationManager.location
            if currentLocation != nil {
                self.latitude = currentLocation.coordinate.latitude
                self.longitude = currentLocation.coordinate.longitude
                self.getAddressFromLatLon(pdblLatitude: self.latitude, withLongitude: self.longitude)
            }
        }
        
     
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        if self.arrImageData.count <= 0 {self.cvPhotosHeight.constant = 0}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentDateAndTime = formatter.string(from: Date())
        tblReportingData.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        objScrollView.setContentOffset(.zero, animated: true)
    }
    
    //MARK:- View Setup
    
    func setUpNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "menu"), for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(self.openCloseMenu(sender:)), for:.touchUpInside)

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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("Error while updating location " + error.localizedDescription)
    }

    func getLocationAddress() {
        
    }
    
    // MARK -
    // MARK: - IBActions
    
    @IBAction func onClickAddPhotoBtn(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func onClickCommencePatrolsBtn(_ sender: UIButton) {
        self.apiCallShiftStart()
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

extension ReportingVC: ImagePickerDelegate {

    func didSelect(image: UIImage?, path: String?) {
        guard let img = image else {
            return
        }
        guard let path = path else {
            return
        }
        
        self.apiCallReportingUploadImage(path: path, img: img )
    }
}

// MARK -
// MARK: - Table Delegates
// MARK:-

extension ReportingVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblReportingData {
            return 5
        } else {
            return checkListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblReportingData {
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
        if tableView == self.tblReportingData {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblReportingData {
            return 50
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tblReportingData {
            if indexPath.row == 1 || indexPath.row == 3 {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatrolAreaAndVehicleUnitDetailVC") as? PatrolAreaAndVehicleUnitDetailVC
                if indexPath.row == 1 {
                    vc?.isForPatrolArea = true
                    vc?.reportingVC = self
                    vc?.arrVehiclePatrolArea = self.arrVehiclePatrolArea
                } else if indexPath.row == 3 {
                    vc?.isForPatrolArea = false
                    vc?.reportingVC = self
                    vc?.arrVehicleUnitList = self.arrVehicleUnitList
                }
                self.navigationController?.pushViewController(vc!, animated: true)
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

extension ReportingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ReportingVC: DeleteImageProtocol {
    func deleteImage(index: Int) {
        self.arrImageData.remove(at: index)
        self.cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
}

extension ReportingVC {
    
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
                        self.tblReportingData.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                        print(addressString)
                  }
            })

        }
    
    func getVehicleUnitApi() {
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        let url = URL(string: AppURL.vehicle_unit )!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            DispatchQueue.main.async {
                //print("Login Response: \(response)")
                if let vehicleUnit = try? JSONDecoder().decode(VehicleUnitWrapper.self, from: data) {
                    ActivityIndicator.shared.hideProgressView()
                    print("vehicle unit status-> \(vehicleUnit.status)")
                    print("vehicle unit status-> \(vehicleUnit.message)")
                    print("vehicle unit count-> \(vehicleUnit.data.vehicleUnitList.count)")
                    self.arrVehicleUnitList = vehicleUnit.data.vehicleUnitList
                    self.selectedVehicleUnit = self.arrVehicleUnitList[0].vehicleName
                    self.selVehicleUnitNumID = self.arrVehicleUnitList[0].vehicleID
                    self.tblReportingData.reloadData()
                    print("====\(self.arrVehicleUnitList)")
                    
                    
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
    
    func getPatrolAreaApi() {
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        let url =  URL(string: AppURL.patrol_area)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            print("get petrol area: \(String(describing: response))")
            
            DispatchQueue.main.async {
                if let petrolData = try? JSONDecoder().decode(PatrolAreaWrapper.self, from: data) {
                    ActivityIndicator.shared.hideProgressView()
                    self.arrVehiclePatrolArea = petrolData.data.vehiclePatrolArea
                    self.selectedPatrolArea = self.arrVehiclePatrolArea[0].patrolAreaName
                    self.selPetrolAreaID = self.arrVehiclePatrolArea[0].patrolID
                    print("====\(self.arrVehiclePatrolArea)")
                    self.tblReportingData.reloadData()
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
    
    func apiCallReportingUploadImage(path: String,img: UIImage){
        
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        
//        if self.arrImageData.count <= 0 {
//            //self.apiCallShiftStart()
//            return
//        }
        
//        var arrFilePath :[String] = []
        
//        for i in 0..<arrImageData.count{
//            arrFilePath.append(arrImageData[i].path)
//        }
        
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
        for i in 0..<self.tblReportingChecklist.numberOfRows(inSection: 0) {
            if let cell = self.tblReportingChecklist.cellForRow(at: IndexPath(row: i, section: 0)) as? ReportingChecklistCell {
                if cell.btnChecklist.isSelected {
                    arrChecklist.append("true")
                } else {
                    arrChecklist.append("false")
                }
            }
        }
        return arrChecklist
    }
    
    func apiCallShiftStart(){
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)

        arrSelectedImageIDs.removeAll()
        for item in arrImageData{
            arrSelectedImageIDs.append(Int(item.imageId!)!)
        }
        
        let strUserid = UserDefaults.standard.getUserID()

        let arrCheckList = resetChecks()
        startKm = self.txtStartKm.text ?? ""
        comments = self.txtComments.text ?? ""
        
        let params = ["latitude": "\(latitude)" ,
                      "longitude":"\(longitude)",
                      "fulladdress":"\(address)",
                      "sc_start_cl_1":"\(arrCheckList[0])",
                      "sc_start_cl_2":"\(arrCheckList[1])",
                      "sc_start_cl_3":"\(arrCheckList[2])",
                      "sc_start_cl_4":"\(arrCheckList[3])",
                      "sc_start_cl_5":"\(arrCheckList[4])",
                      "user_id":"\(strUserid)",
                      "patrol_id":"\(selPetrolAreaID)",
                      "shift_start_time":currentDateAndTime,
                      "shift_vehicle_unit":"\(selVehicleUnitNumID)",
                      "shift_start_comments":"\(comments)",
                      "shift_start_km":"\(startKm)",
                      "image":arrSelectedImageIDs] as [String : Any]

        for (key, value) in params {
           print("** Reporting Key:(\(key),Value: \(value))")
        }

        ApiCall().post(apiUrl: AppURL.shiftStart , params: params, model: ShiftStartWrapper.self) {
            result in
            ActivityIndicator.shared.hideProgressView()
            switch result {
            case .success(let response):
                print(response)
                self.arrImageData.removeAll()
                self.arrSelectedImageIDs.removeAll()
                print("** ReportingView Response: \(response)")
                let userData = User(loginUserName: UserDefaults.standard.getUserName(), shiftId: response.shift_id, time: self.currentDateAndTime, userId: UserDefaults.standard.getUserID(), userData: self.loginData, petrolId: self.selPetrolAreaID, arrVehicleUnitList: self.arrVehicleUnitList, arrVehiclePetrolArea: self.arrVehiclePatrolArea, address: self.address, latitude: String(self.latitude), longitude: String(self.longitude), selectedVehicleUnit: self.selectedVehicleUnit, selVehicleUnitNumID: self.selVehicleUnitNumID, selectedPatrolArea: self.selectedPatrolArea, selPetrolAreaID: self.selPetrolAreaID)
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                vc?.userData = userData
                self.navigationController?.pushViewController(vc!, animated: true)
            case .failure(let failureResponse):
                print(failureResponse.message ?? "")
            case .error(let e):
                print(e ?? "")
            }
        }
    }
}
