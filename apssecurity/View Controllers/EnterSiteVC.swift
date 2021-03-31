//
//  EnterSiteVC.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit

class EnterSiteVC: UIViewController {
    
    // MARK -
    // MARK: - OUTLETS
    
    @IBOutlet weak var objScrollView: UIScrollView!
    
    @IBOutlet weak var objParentView: UIView!
    
    @IBOutlet weak var objUserDataView: UIView!
    @IBOutlet weak var tblUserData: UITableView!
    @IBOutlet weak var objTblHeaderView: UIView!
    @IBOutlet weak var lblTblHeader: UILabel!
    
    @IBOutlet weak var objParentStackView: UIStackView!
    
    @IBOutlet weak var objAnyPersonOnSiteStackView: UIStackView!
    @IBOutlet weak var objAnyPersonOnSiteChildStackView: UIStackView!
    @IBOutlet weak var objAnyPersonOnSiteSwitch: UISwitch!
    @IBOutlet weak var objVehicleRegoTxt: UITextField!
    @IBOutlet weak var objVehicleDescTxt: UITextField!
    @IBOutlet weak var objFullNameTxt: UITextField!
    @IBOutlet weak var objRelationWithSiteLbl: UILabel!
    @IBOutlet weak var objCompanyNameTxt: UITextField!
    @IBOutlet weak var objReasonForPresenseTxt: UITextField!
    @IBOutlet weak var objPhotoIdTxt: UITextField!
    @IBOutlet weak var objAuthorisedPresenseSwitch: UISwitch!
    @IBOutlet weak var objAdditionalDetailsTxt: UITextField!
    
    @IBOutlet weak var objAnyDamageOnSiteStackView: UIStackView!
    @IBOutlet weak var objAnyDamageOnSiteChildStackView: UIStackView!
    @IBOutlet weak var objAnyDamageOnSiteSwitch: UISwitch!
    @IBOutlet weak var objActivityTypeLbl: UILabel!
    @IBOutlet weak var objDamageDetailsTxt: UITextField!
    @IBOutlet weak var objPoliceInformedSwitch: UISwitch!
    @IBOutlet weak var objPoliceInformedDetailsTxt: UITextField!
    @IBOutlet weak var objAfterHoursInformedSwitch: UISwitch!
    @IBOutlet weak var objAfterHoursInformedDetailsTxt: UITextField!
    
    @IBOutlet weak var objAnyEquipmentExposedStackView: UIStackView!
    @IBOutlet weak var objAnyEquipmentExposedChildStackView: UIStackView!
    @IBOutlet weak var objAnyEquipmentExposedSwitch: UISwitch!
    @IBOutlet weak var objAnyEquipmentExposedDetailsTxt: UITextField!
    
    @IBOutlet weak var objAllLockSecuredSwitch: UISwitch!
    
    @IBOutlet weak var objSiteArmedSwitch: UISwitch!
    
    @IBOutlet weak var objAdditionalDetailsMainTxt: UITextField!
    @IBOutlet weak var btnAddPhotos: UIButton!
    @IBOutlet weak var btnSubmitDetails: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var cvPhotosHeight: NSLayoutConstraint!
    
    @IBOutlet weak var alarmTimepicker: UIDatePicker!
    @IBOutlet weak var viewTimePicker: UIView!
    @IBOutlet weak var pickerViewHeightConstraint:NSLayoutConstraint!
    // MARK -
    // MARK: - VARIABLES
    
    var userData: User?
    
    var arrActivity: [IDActivityData] = []
    var arrRelation: [IDRelationData] = []
    var arrSite: [IDSiteData] = []
    var arrCheck: [IDCheckData] = []
    var arrAttendance: [IDAttendanceData] = []
    var dicIDDropData : IDDropDownData?
    
    var timeOfAlarmAct = ""
    
    var selSiteId = ""
    var selSite = ""
    var selSiteBrief = ""
    
    var selAttendenceTypeId = ""
    var selAttendenceType = ""
    
    var selCheckTypeId = ""
    var selCheckType = ""
    
    var imagePicker: ImagePicker!
    var arrImageData = [ImageData]()
    var arrSelectedImageIDs : [Int] = []
    
    var selRelationshipTypeId = ""
    var selRelationshipType = "" {
        didSet {
            self.objRelationWithSiteLbl.text = selRelationshipType
        }
    }
    
    var selActivityTypeId = ""
    var selActivityType = "" {
        didSet {
            self.objActivityTypeLbl.text = selActivityType
        }
    }
    
    var currentDateTime = ""
  
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerViewHeightConstraint.constant = 0
        // Do any additional setup after loading the view.
        self.title = "Inspection Details"
        if let user = userData {
            self.lblTblHeader.text = user.loginUserName
            
//            let inFormatter = DateFormatter()
//            inFormatter.locale = Locale(identifier: "en_US_POSIX")
//            inFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            let outFormatter = DateFormatter()
//            outFormatter.locale = Locale(identifier: "en_US_POSIX")
//            outFormatter.dateFormat = "HH:mm"

//            let date = inFormatter.date(from: user.time)!
//            timeOfAlarmAct = outFormatter.string(from: date)
        }
        self.getIDDropDataApi()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        if self.arrImageData.count <= 0 {self.cvPhotosHeight.constant = 0}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentDateTime = formatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
    
    @IBAction func onClickAnyPersonOnSiteSwitch(_ sender: UISwitch) {
        self.objAnyPersonOnSiteChildStackView.isHidden = !(sender.isOn)
    }
    
    @IBAction func onClickAuthorisedPresenseSwitch(_ sender: UISwitch) {}
    
    @IBAction func onClickAnyDamageOnSiteSwitch(_ sender: UISwitch) {
        self.objAnyDamageOnSiteChildStackView.isHidden = !(sender.isOn)
    }
    
    @IBAction func onClickPoliceInformedSwitch(_ sender: UISwitch) {}
    
    @IBAction func onClickAfterHoursInformedSwitch(_ sender: UISwitch) {}
    
    @IBAction func onClickAnyEquipmentExposedSwitch(_ sender: UISwitch) {
        self.objAnyEquipmentExposedChildStackView.isHidden = !(sender.isOn)
    }
    
    @IBAction func onClickAllLockSecuredSwitch(_ sender: UISwitch) {}
    
    @IBAction func onClickSiteArmedSwitch(_ sender: UISwitch) {}
    
    @IBAction func onClickRelationBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatrolAreaAndVehicleUnitDetailVC") as? PatrolAreaAndVehicleUnitDetailVC
        vc?.index = 10
        vc?.enterSiteVC = self
        vc?.arrRelation = self.arrRelation
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func onClickActivityBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatrolAreaAndVehicleUnitDetailVC") as? PatrolAreaAndVehicleUnitDetailVC
        vc?.index = 11
        vc?.enterSiteVC = self
        vc?.arrActivity = self.arrActivity
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func onClickAddPhotoBtn(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func onClickSubmitBtn(_ sender: UIButton) {
        self.submitDetailValidation()
    }

    func showHidePickerView(show:Bool){
        UIView.animate(withDuration: 3.0, animations: {
            self.pickerViewHeightConstraint.constant = show ? 256 : 0
        })
    }

    // MARK: - Actions
    @IBAction func pickerOnclickDone(_ sender: Any) {
        showHidePickerView(show: false)
        
    }
    
    @IBAction func pickerOnclickCancel(_ sender: Any) {
        showHidePickerView(show: false)
    }
    
    
    @IBAction func onClickTimerPicker(_ sender: Any) {
        let formatter = DateFormatter()
        //formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        timeOfAlarmAct = formatter.string(from: (sender as! UIDatePicker).date)
        tblUserData.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
    }
    
    func openTimePicker()  {
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        timePicker.center = self.view.center
        timePicker.backgroundColor = UIColor.white
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(startTimeDiveChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        //formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        timeOfAlarmAct = formatter.string(from: sender.date)
        timePicker.removeFromSuperview() // if you want to remove time picker
        tblUserData.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
    }
}

extension EnterSiteVC: ImagePickerDelegate {

    func didSelect(image: UIImage?, path: String?) {
        guard let img = image else {
            return
        }
        guard let path = path else {
            return
        }
        
        self.apiCallInspectionUploadImage(path: path, img: img )
        
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

extension EnterSiteVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblUserData {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblUserData {
            if indexPath.row == 7 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectorAlarmCell", for: indexPath) as? SectorAlarmCell else {
                    return UITableViewCell()
                }
                return cell;
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportingDataCell", for: indexPath) as? ReportingDataCell else {
                    return UITableViewCell()
                }
                if let user = userData {
                    cell.setDataForEnterSite(indexPath: indexPath, site: selSite, time: currentDateTime, address: user.address, attendenceType: selAttendenceType, checkType: selCheckType, timeOfAlarmAct: timeOfAlarmAct, vc: self)
                }
                return cell;
            }
        }
        return UITableViewCell()
    }
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblUserData {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblUserData {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tblUserData {
            
            if indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5 {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatrolAreaAndVehicleUnitDetailVC") as? PatrolAreaAndVehicleUnitDetailVC
                vc?.index = indexPath.row
                vc?.enterSiteVC = self
                vc?.arrSite = self.arrSite
                vc?.arrAttendance = self.arrAttendance
                vc?.arrCheck = self.arrCheck
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == 1  {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SiteBriefVC") as? SiteBriefVC
                vc?.enterSiteVC = self
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == 6 {
                showHidePickerView(show: true)
            }
        }
    }
}

// MARK -
// MARK: - CollectionView Delegates
// MARK:-

extension EnterSiteVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension EnterSiteVC: DeleteImageProtocol {
    func deleteImage(index: Int) {
        self.arrImageData.remove(at: index)
        self.cvPhotos.reloadData()
        self.arrImageData.count > 0 ? (self.cvPhotosHeight.constant = 120) : (self.cvPhotosHeight.constant = 0)
    }
}


extension EnterSiteVC {
    
    
    func getIDDropDataApi() {
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        let url = URL(string: AppURL.drops_data )!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            DispatchQueue.main.async {
                print("Login Response: \(String(describing: response))")
                ActivityIndicator.shared.hideProgressView()
                if let idDropData = try? JSONDecoder().decode(InspectionDetailsDropDataWrapper.self, from: data) {
                    if idDropData.status == 1 {
                        self.dicIDDropData = idDropData.data
                        self.arrActivity = idDropData.data.activity
                        self.arrRelation = idDropData.data.relation
                        self.arrSite = idDropData.data.site
                        self.arrCheck = idDropData.data.check
                        self.arrAttendance = idDropData.data.attendance
                        
                        self.selSiteId = self.arrSite.first?.site_id ?? ""
                        self.selSite = self.arrSite.first?.site_name ?? ""
                        self.selSiteBrief = self.arrSite.first?.site_brief ?? ""
                        
                        self.selAttendenceTypeId = self.arrAttendance.first?.attendance_type_id ?? ""
                        self.selAttendenceType = self.arrAttendance.first?.attendance_details ?? ""
                        
                        self.selCheckTypeId = self.arrCheck.first?.check_type_id ?? ""
                        self.selCheckType = self.arrCheck.first?.check_type_details ?? ""
                        self.tblUserData.reloadData()
                        
                        self.selRelationshipTypeId = self.arrRelation.first?.relationship_id ?? ""
                        self.selRelationshipType = self.arrRelation.first?.relationship_descript ?? ""
                        
                        self.selActivityTypeId = self.arrActivity.first?.activity_id ?? ""
                        self.selActivityType = self.arrActivity.first?.activity_details ?? ""
                    }
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
    
    func submitDetailValidation() {
        var msg = ""
        
        if self.selAttendenceType == "Alarm Response" && timeOfAlarmAct == ""{
            msg += "Enter Time of Alarm Activation \n"
        }
        
        if self.objAnyPersonOnSiteSwitch.isOn {
            
            if let vehicleRego = objVehicleRegoTxt.text {
                if vehicleRego.isEmpty {
                    msg += "Enter Vehicle Rego \n"
                }
            }
            if let vehicleDesc = objVehicleDescTxt.text {
                if vehicleDesc.isEmpty {
                    msg += "Enter Vehicle Description \n"
                }
            }
            if let fullName = objFullNameTxt.text {
                if fullName.isEmpty {
                    msg += "Enter Full Name \n"
                }
            }
            if let companyName = objCompanyNameTxt.text {
                if companyName.isEmpty {
                    msg += "Enter Company Name \n"
                }
            }
            if let reasonForPresence = objReasonForPresenseTxt.text {
                if reasonForPresence.isEmpty {
                    msg += "Enter Reason For Presence \n"
                }
            }
            
            if let photoID = objPhotoIdTxt.text{
                if photoID.isEmpty {
                    msg += "Enter Photo ID \n"
                }
            }
            
        }
        
        if self.objAnyDamageOnSiteSwitch.isOn {
            
            if let damageDetails = objDamageDetailsTxt.text {
                if damageDetails.isEmpty {
                    msg += "Enter Damage Details \n"
                }
            }
        }
        
        if self.objPoliceInformedSwitch.isOn{
        if let stationDetails = objPoliceInformedDetailsTxt.text {
            if stationDetails.isEmpty {
                msg += "Enter Station Details \n"
            }
        }
        }
        
        if self.objAnyEquipmentExposedSwitch.isOn {
            if let details = objAnyEquipmentExposedDetailsTxt.text {
                if details.isEmpty {
                    msg += "Enter Damage Equipment Details"
                }
            }
        }
        

        
        if msg.isEmpty {
            self.apiCallInspectionDetails()
//           ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
//            if self.arrImageData.count > 0 {
//                self.apiCallInspectionUploadImage()
//            }else{
//            }
        } else {
            // SHow Alert
            self.showAlert(message: msg, title: "Enter Field Data", OKActionText: "OK")
        }
    }
    
    func apiCallInspectionUploadImage(path: String,img: UIImage){
        
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)
        
        let arrFiles = [
            [MultiPart.fieldName: "file",
             MultiPart.pathURLs: [path]]
        ]
        //https://apsreporting.com.au/api/User/insert_file  //single File
        //https://apsreporting.com.au/api/User/upload  // Multiple
        // With Model Object
        MultiPart().callPostWSWithModel(AppURL.insert_file, parameters: nil, filePathArr: arrFiles, model: InsertFileWrapper.self) {
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
    
    func apiCallInspectionDetails(){
        ActivityIndicator.shared.showProgressView(self.navigationController?.view ?? self.view)

        arrSelectedImageIDs.removeAll()
        for item in arrImageData{
            arrSelectedImageIDs.append(Int(item.imageId!)!)
        }
        
        var sectorInAlarm = ""
        let noOfRows = self.tblUserData.numberOfRows(inSection: 0)
        if let cell = self.tblUserData.cellForRow(at: IndexPath(row: noOfRows-1, section: 0)) as? SectorAlarmCell {
            sectorInAlarm = cell.txtField.text ?? ""
        }
        if userData == nil {return}
        
        
    
        let params = ["latitude":"\(String(describing: userData!.latitude))",
                      "longitude":"\(String(describing: userData!.longitude))",
                      "fulladdress":"\(String(describing: userData!.address))",
                      "site_presence_vrego":"\(self.objVehicleRegoTxt.text ?? "")",
                      "site_presence_vdesc":"\(self.objVehicleDescTxt.text ?? "")",
                      "site_presence_name":"\(self.objFullNameTxt.text ?? "")",
                      "site_relationship_id":selRelationshipTypeId,
                      "site_presence_compname":"\(self.objCompanyNameTxt.text ?? "")",
                      "site_presence_reasonofpre":"\(self.objReasonForPresenseTxt.text ?? "")",
                      "site_presence_idno":"\(self.objPhotoIdTxt.text ?? "")",
                      "site_presence_authority":"\(self.objAuthorisedPresenseSwitch.isOn)",
                      "site_presence_add_details":"\(self.objAdditionalDetailsTxt.text ?? "")",
                      "site_damage_act_id":"\(selActivityTypeId)",
                      "site_damage_damage_det":"\(self.objDamageDetailsTxt.text ?? "")",
                      "police_informed":"\(self.objPoliceInformedSwitch.isOn)",
                      "police_details":"\(self.objPoliceInformedDetailsTxt.text ?? "")",
                      "site_damage_after_hr_inf":"\(self.objAfterHoursInformedSwitch.isOn)",
                      "site_damage_addt_detail":"\(self.objAfterHoursInformedDetailsTxt.text ?? "")",
                      "esposed_details":"\(self.objAnyEquipmentExposedDetailsTxt.text ?? "")",
                      "locked_secured":"\(self.objAllLockSecuredSwitch.isOn)",
                      "time":currentDateTime,//"\(updatedDate.newDate)",
                      "site_armed":"\(self.objSiteArmedSwitch.isOn)",
                      "additional_notes":"\(self.objAdditionalDetailsMainTxt.text ?? "")",
                      "image_id":arrSelectedImageIDs,
                      "site_id":selSiteId,
                      "shift_id":"\(self.userData!.shiftId)",
                      "attendance_id":selAttendenceTypeId,
                      "check_id":selCheckTypeId,
                      "time_of_alarm": timeOfAlarmAct,
                      "sector_alarm":"\(sectorInAlarm)",
                      "any_person":"\(self.objAnyPersonOnSiteSwitch.isOn)",
                      "any_damage":"\(self.objAnyDamageOnSiteSwitch.isOn)",
                      "equipment_exposed":"\(self.objAnyEquipmentExposedSwitch.isOn)"] as [String : Any]
        
        
        for (key, value) in params {
           print("** InspectionDetails Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: AppURL.siteReport , params: params, model: SiteReportWrapper.self) {
            result in
            ActivityIndicator.shared.hideProgressView()
            switch result {
            case .success(let response):
                self.arrImageData.removeAll()
                self.arrSelectedImageIDs.removeAll()
                //print(response)
                print("** InspectionDetails Response: \(response)")
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveSiteVC") as! LeaveSiteVC
                vc.report_id  = response.site_report_id
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let failureResponse):
                print(failureResponse.message ?? "")
            case .error(let e):
                print(e ?? "")
            }
        }
    }
    
}
