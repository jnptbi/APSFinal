//
//  InspectionDetailsView.swift
//  APS Security
//
//  Created by Vishal Patel on 29/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI
import Photos

struct InspectionDetailsView: View {
    
    @ObservedObject var idDropDataObserver = IDDropDataObserver()
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var locationManager = LocationManager2()
    
    @ObservedObject var updatedDate = TimerHolder()
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var address: String {
        return "\(locationManager.address ?? "Not found")"
    }
    
    @State var inspectionDate: String
    @State private var selSiteIndex = 0
    @State private var selAttendenceTypeIndex = 0
    @State private var selCheckTypeIndex = 0
    @State private var relationshipWithSiteIndex = 0
    @State private var activityType = 0
    @State private var selSiteID = ""
    @State private var selAttendenceTypeID = ""
    @State private var selCheckTypeID = ""
    @State private var relationshipWithSiteID = 0
    @State private var activityTypeID = ""
    
    @State private var timeAlarmActivation = Date()
    @State private var sectorInAlarm = ""
    
    @State private var isPersonOnSite : Bool = false
    @State private var vehicleRego = ""
    @State private var vehicleDescription = ""
    @State private var fullName = ""
    @State private var companyName = ""
    @State private var reasonForPresence = ""
    @State private var photoId = ""
    @State private var authorisedPresence : Bool = true
    @State private var additionalDetails = ""
    
    @State private var isDamageOnSite : Bool = false
    @State private var damageDetails = ""
    @State private var policeInformed : Bool = false
    @State private var stationDetails = ""
    @State private var afterHourInformed : Bool = true
    @State private var damageAdditionalDetails = ""
    
    @State private var isEquipmentExposed : Bool = false
    @State private var details = ""
    @State private var allLocckSecured : Bool = false
    @State private var siteArmedNow : Bool = false
    @State private var additionalNotes = ""
    
    @State private var gotoNextView: Bool? = false
    
    @State var showSiteBrief: Bool = false
    @State var siteBriefStr: String = "Site Brief"
    
    @ObservedObject var user: User
    
    //Image Data
    @State var showSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var selected : [InspectionSelectedImages] = []
    @State var showLibraryPicker = false
    //@State var value:CGFloat = 0
    @State var showLoadingIndicator: Bool = false
    @State var arrSelectedImageIDs : [Int] = []
    
    @State var selectedSiteName: String = ""
    @State var selectedSiteBrief: String = ""
    
    @State private var shouldShowErrorAlert: Bool = false
    @State private var message = ""
    
    @State var isEdited = false

    var timeFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en_GB")
            return dateFormatter
    }
    
    var body: some View {
        
        return ZStack{
            Form {
                
                Group {
                    HStack {
                        Spacer()
                        Text("\(user.loginUserName)")
                            .font(.title)
                        //.foregroundColor(Color.gray)
                        Spacer()
                    }
                }
                
                Group {
                    if !idDropDataObserver.Loading{
                        Picker(selection: $selSiteIndex , label: Text("Site")) {
                            ForEach(0 ..< idDropDataObserver.arrSite.count) { selSiteIndex in
                                 Text(self.idDropDataObserver.arrSite[selSiteIndex].site_name)
                                    .tag(selSiteIndex)
                            }
                        }.onReceive(idDropDataObserver.arrSite.publisher.first()) { value in
                            
                        }
                    }
                    
                    if idDropDataObserver.hasSiteArrayFound {
                        
                        NavigationLink.init(destination: SiteBrief(siteTitle: self.idDropDataObserver.arrSite[selSiteIndex].site_name , siteDescription: self.idDropDataObserver.arrSite[selSiteIndex].site_brief, backToInspectinDetails: self.$showSiteBrief), isActive: self.$showSiteBrief) {
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    self.showSiteBrief = true
                                }) {
                                    Text.init("Read Site Brief")
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 20)
                                }
                                .buttonStyle(MyButtonStyle())
                            }
                            
                        }
                        .isDetailLink(false)
                        .onReceive(self.appState.$moveToInspectionDetail) { moveToInspectionDetail in
                            if moveToInspectionDetail {
                                print("MoveToInspectionDetail: \(moveToInspectionDetail)")
                                self.showSiteBrief = false
                                self.appState.moveToInspectionDetail = false
                            }
                        }
                        
                    }
                    
                    HStack {
                        Text("Time on Site")
                        Spacer()
                        Text(inspectionDate)
                            .foregroundColor(Color.gray)
                    }
                    
                    HStack {
                        Text("Address")
                        Spacer()
                        Text("\(address)")
                            .foregroundColor(Color.gray)
                    }
                    
                    if !idDropDataObserver.Loading{
                        Picker(selection: $selAttendenceTypeIndex , label: Text("Attendence Type")) {
                            ForEach(0 ..< idDropDataObserver.arrAttendance.count) { selAttendenceTypeIndex in
                                Text(self.idDropDataObserver.arrAttendance[selAttendenceTypeIndex].attendance_details)
                                    .tag(selAttendenceTypeIndex)
                            }
                        }.onReceive(idDropDataObserver.arrAttendance.publisher.first()) { value in
                        }
                    }
                    
                    if !idDropDataObserver.Loading{
                        Picker(selection: $selCheckTypeIndex , label: Text("Check Type")) {
                            ForEach(0 ..< idDropDataObserver.arrCheck.count) { selCheckTypeIndex in
                                Text(self.idDropDataObserver.arrCheck[selCheckTypeIndex].check_type_details)
                                    .tag(selCheckTypeIndex)
                            }
                        }.onReceive(idDropDataObserver.arrCheck.publisher.first()) { value in
                        }
                    }
                    
                    DatePicker("Enter time of alarm activation", selection: $timeAlarmActivation, displayedComponents: .hourAndMinute)
                    
                    TextField("Enter sector in alarm", text: $sectorInAlarm)
                    
                }
                
                
                Group{
                    
                    Section(header: Toggle(isOn: $isPersonOnSite) {
                        Text("Any Person on Site")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.darkGray))
                    }.listRowInsets(EdgeInsets())
                    .padding(.all)
                    .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))) {
                        if isPersonOnSite {
                            TextField("Vehicle Rego", text: $vehicleRego)
                            TextField("Vehicle Description", text: $vehicleDescription)
                            TextField("Full Name", text: $fullName)
                            if !idDropDataObserver.Loading{
                                Picker(selection: $relationshipWithSiteIndex , label: Text("Relationship with site")) {
                                    ForEach(0 ..< idDropDataObserver.arrRelation.count) { relationshipWithSiteIndex in
                                        Text(self.idDropDataObserver.arrRelation[relationshipWithSiteIndex].relationship_descript)
                                            .tag(relationshipWithSiteIndex)
                                    }
                                }.onReceive(idDropDataObserver.arrRelation.publisher.first()) { value in
                                }
                            }
                            TextField("Company Name", text: $companyName)
                            TextField("Reason for Presence", text: $reasonForPresence)
                            TextField("Photo Id", text: $photoId)
                            Section(header: Toggle(isOn: $authorisedPresence) {
                                Text("Authorised Presence")
                                    .font(.system(size: 22))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.darkGray))
                            }.listRowInsets(EdgeInsets())
                            .padding(.all)
                            .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))){
                                TextField("Additional Details", text: $additionalDetails)
                            }
                        }
                    }
                    
                    Section(header: Toggle(isOn: $isDamageOnSite) {
                        Text("Any Damage on Site")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.darkGray))
                    }.listRowInsets(EdgeInsets())
                    .padding(.all)
                    .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))) {
                        if isDamageOnSite {
                            if !idDropDataObserver.Loading{
                                Picker(selection: $activityType , label: Text("Activity Type")) {
                                    ForEach(0 ..< idDropDataObserver.arrActivity.count) { activityType in
                                        Text(self.idDropDataObserver.arrActivity[activityType].activity_details)
                                            .tag(activityType)
                                    }
                                }.onReceive(idDropDataObserver.arrActivity.publisher.first()) { value in
                                }
                            }
                            
                            TextField("Damage Details", text: $damageDetails)
                            
                            Section(header: Toggle(isOn: $policeInformed) {
                                Text("Police Informed")
                                    .font(.system(size: 22))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.darkGray))
                            }.listRowInsets(EdgeInsets())
                            .padding(.all)
                            .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))){
                                TextField("Station Details", text: $stationDetails)
                            }
                            
                            Section(header: Toggle(isOn: $afterHourInformed) {
                                Text("after-hour informed")
                                    .font(.system(size: 22))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.darkGray))
                            }.listRowInsets(EdgeInsets())
                            .padding(.all)
                            .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))){
                                TextField("Additional Details", text: $damageAdditionalDetails)
                            }
                        }
                    }
                    
                    Section(header: Toggle(isOn: $isEquipmentExposed) {
                        Text("Any equipment exposed")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.darkGray))
                    }.listRowInsets(EdgeInsets())
                    .padding(.all)
                    .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))) {
                        if isEquipmentExposed {
                            
                            MultilineTextField("Enter details", text: self.$details, onCommit: {
                                print("Final comments: \(self.details)")
                            })
                            /*
                             Toggle(isOn: $allLocckSequired) {
                             Text("All Locked & Sequired Now")
                             }
                             Toggle(isOn: $siteArmedNow) {
                             Text("Site Armed Now")
                             }
                             
                             MultilineTextField("Additional notes", text: self.$additionalNotes, onCommit: {
                             print("Final comments: \(self.additionalNotes)")
                             })
                             */
                            
                            
                        }
                    }
                    
                    Section(header: Toggle(isOn: $allLocckSecured) {
                        Text("All Locked & Secured Now")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.darkGray))
                    }.listRowInsets(EdgeInsets())
                    .padding(.all)
                    .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))){}
                    
                    Section(header: Toggle(isOn: $siteArmedNow) {
                        Text("Site Armed Now")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.darkGray))
                    }.listRowInsets(EdgeInsets())
                    .padding(.all)
                    .background(Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)))){}
                    
                    MultilineTextField("Additional Details", text: self.$additionalNotes, onCommit: {
                        print("Final comments: \(self.additionalNotes)")
                    })
                    
                }
                
                Section(header: ImageHeader(showSheet: $showSheet)) {
                    
                    if !self.selected.isEmpty{
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(){
                                ForEach(self.selected,id: \.self){i in
                                    ZStack{
                                        VStack{
                                            Image(uiImage: i.image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width - 70, height: 250)
                                        }.background(Color(UIColor.lightGray).opacity(0.5))
                                        .cornerRadius(15)
                                        .padding(.all , 15)
                                        
                                        VStack{
                                            HStack{
                                                Spacer()
                                                Button(action: {
                                                    if let index = self.selected.firstIndex(of: i){
                                                        self.selected.remove(at: index)
                                                    }
                                                }) {
                                                    Image("delete")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                }.frame(width: 40, height: 40 , alignment: .trailing)
                                                .padding(.trailing, 10)
                                            }
                                            Spacer()
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        
                        submitDetailValidation()
                        /*
                        if self.selected.count > 0 {
                            self.apiCallInspectionUploadImage()
                        }else{
                            self.apiCallInspectionDetails()
                        }
                        */
                        
                    }) {
                        Text.init("Submit details")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                        
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    NavigationLink(destination: ExitSite(), tag: true, selection: self.$gotoNextView) {
                        EmptyView()
                    }
                }.actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                        .default(Text("Photo Library")) {
                            // self.selected.removeAll()
                            self.showLibraryPicker.toggle()
                        },
                        .default(Text("Camera")) {
                            //   self.selected.removeAll()
                            self.showImagePicker = true
                            self.sourceType = .camera
                        },
                        .cancel()
                    ])
                }
            }
            
            if self.showLibraryPicker{
                InspectionCustomPicker(selected: self.$selected, show: self.$showLibraryPicker)
            }
            if self.showImagePicker{
                InspectionImageImagePicker(selected: $selected, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }

            if self.showLoadingIndicator{
                ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .gradient([.white, .red]))
                    .frame(width: 60.0, height: 60.0)
            }
        }.disabled(self.showLoadingIndicator)
        .navigationBarTitle("Inspection Details")
        //.padding(.bottom, keyboard.currentHeight)
        //.animation(.spring())
        .alert(isPresented: $shouldShowErrorAlert) {
            Alert(title: Text("Enter Field Data"), message:  Text(self.message), dismissButton: .default(Text("OK")))
        }
    }
    
    func apiCallInspectionUploadImage(){
        var arrFilePath :[String] = []
        
        for data in selected{
            arrFilePath.append(data.path)
        }
        
        let arrFiles = [
            [MultiPart.fieldName: "files[]",
             MultiPart.pathURLs: arrFilePath]
        ]
        
        // With Model Object
        MultiPart().callPostWSWithModel("https://apsreporting.com.au/api/User/upload", parameters: nil, filePathArr: arrFiles, model: uploadImagesWrapper.self) {
            result in
            switch result {
            case .success(let response):
                print(response)
                let data = response as uploadImagesWrapper
                for item in data.image_id {
                    self.arrSelectedImageIDs.append(item[0])
                }
                self.apiCallInspectionDetails()
            case .failure(let failureResponse):
                showLoadingIndicator = false
                print(failureResponse.message ?? "")
            case .error(let e):
                showLoadingIndicator = false
                print(e ?? "")
            }
        }
    }
    
    func apiCallInspectionDetails(){
        
        if idDropDataObserver.arrSite.count > 0{
            selSiteID = idDropDataObserver.arrSite[selSiteIndex].site_id
        }
        if idDropDataObserver.arrCheck.count > 0{
            selCheckTypeID = idDropDataObserver.arrCheck[selCheckTypeIndex].check_type_id
        }
        if idDropDataObserver.arrActivity.count > 0{
            activityTypeID = idDropDataObserver.arrActivity[activityType].activity_id
        }
        if idDropDataObserver.arrRelation.count > 0{
            relationshipWithSiteID = Int(idDropDataObserver.arrRelation[relationshipWithSiteIndex].relationship_id) ?? 0
            
            print("** relationshipWithSiteID: \(relationshipWithSiteID)")
        } else {
            print("** arrRelation is nil")
        }
        
        if idDropDataObserver.arrAttendance.count > 0{
            selAttendenceTypeID = idDropDataObserver.arrAttendance[selAttendenceTypeIndex].attendance_type_id
        }
        
        print("** timeAlarmActivation: \(timeFormatter.string(from: timeAlarmActivation))")
        print("** InspectionDetailsView Address: \(address)")
        
        var anyPersonBool: String {
        
            if isPersonOnSite {
                return "true"
            }
            return "false"
        }
        
        var anyDamageBool: String {
        
            if isDamageOnSite {
                return "true"
            }
            return "false"
        }
        
        var isEquipmentExposedBool: String {
        
            if isEquipmentExposed {
                return "true"
            }
            return "false"
        }
    
        let params = ["latitude":"\(userLatitude)",
                      "longitude":"\(userLongitude)",
                      "fulladdress":"\(address)",
                      "site_presence_vrego":"\(vehicleRego)",
                      "site_presence_vdesc":"\(vehicleDescription)",
                      "site_presence_name":"\(fullName)",
                      "site_relationship_id":relationshipWithSiteID,
                      "site_presence_compname":"\(companyName)",
                      "site_presence_reasonofpre":"\(reasonForPresence)",
                      "site_presence_idno":"\(photoId)",
                      "site_presence_authority":"\(authorisedPresence)",
                      "site_presence_add_details":"\(additionalDetails)",
                      "site_damage_act_id":"\(activityTypeID)",
                      "site_damage_damage_det":"\(damageDetails)",
                      "police_informed":"\(policeInformed)",
                      "police_details":"\(stationDetails)",
                      "site_damage_after_hr_inf":"\(afterHourInformed)",
                      "site_damage_addt_detail":"\(damageAdditionalDetails)",
                      "esposed_details":"\(details)",
                      "locked_secured":"\(allLocckSecured)",
                      "time":"\(updatedDate.newDate)",
                      "site_armed":"\(siteArmedNow)",
                      "additional_notes":"\(additionalNotes)",
                      "image_id":arrSelectedImageIDs,
                      "site_id":selSiteID,
                      "shift_id":"\(self.user.shiftId)",
                      "attendance_id":selAttendenceTypeID,
                      "check_id":selCheckTypeID,
                      "time_of_alarm": timeFormatter.string(from: timeAlarmActivation), //"\(timeAlarmActivation)",
                      "sector_alarm":"\(sectorInAlarm)",
                      "any_person":anyPersonBool,
                      "any_damage":anyDamageBool,
                      "equipment_exposed":isEquipmentExposedBool] as [String : Any]
        
        
        for (key, value) in params {
           print("** InspectionDetails Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: "https://apsreporting.com.au/api/User/siteReport", params: params, model: SiteReportWrapper.self) {
            result in
            self.showLoadingIndicator = false
            switch result {
            case .success(let response):
                //print(response)
                print("** InspectionDetails Response: \(response)")
                self.gotoNextView = true
            case .failure(let failureResponse):
                print(failureResponse.message ?? "")
            case .error(let e):
                print(e ?? "")
            }
        }
    }
    
    func submitDetailValidation() {
        var msg = ""
        if isPersonOnSite {
            
            if vehicleRego.isEmpty {
                msg += "Enter Vehicle Rego \n"
            }
            
            if vehicleDescription.isEmpty {
                msg += "Enter Vehicle Description \n"
            }
            
            if fullName.isEmpty {
                msg += "Enter Full Name \n"
            }
            
            if companyName.isEmpty {
                msg += "Enter Company Name \n"
            }
            
            if reasonForPresence.isEmpty {
                msg += "Enter Reason For Presence \n"
            }
            
        }
        
        if isDamageOnSite {
            
            if damageDetails.isEmpty {
                msg += "Enter Damage Details \n"
            }
            
            if stationDetails.isEmpty {
                msg += "Enter Station Detail \n"
            }
        }
        
        if isEquipmentExposed {
            if details.isEmpty {
                msg += "Enter Damage Equipment Details"
            }
        }
        
        self.message = msg
        
        if message.isEmpty {
            showLoadingIndicator = true
            if self.selected.count > 0 {
                self.apiCallInspectionUploadImage()
            }else{
                self.apiCallInspectionDetails()
            }
            
        } else {
            // SHow Alert
            self.shouldShowErrorAlert = true
        }
    }
}


struct SiteBrief: View {
    
    @State var siteTitle: String
    @State var siteDescription: String
    @Binding var backToInspectinDetails: Bool
    //@EnvironmentObject var appState: AppState
    
    @ObservedObject var updatedDate = TimerHolder()
    let formatter = DateFormatter()
    
    var body: some View {
        
        VStack {
            Spacer()
            Text(siteDescription)
                .padding(40)
                .multilineTextAlignment(.center)
                //.frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Button(action: {
                //self.appState.moveToInspectionDetail = true
                self.backToInspectinDetails = false
            }) {
                Text("OK")
            }
            .buttonStyle(MyButtonStyle())
        }
        .navigationTitle(siteTitle)
    }
}

class IDDropDataObserver : ObservableObject{
    
    @Published var arrActivity: [IDActivityData] = []
    @Published var arrRelation: [IDRelationData] = []
    @Published var arrSite: [IDSiteData] = []
    @Published var arrCheck: [IDCheckData] = []
    @Published var arrAttendance: [IDAttendanceData] = []
    @Published var dicIDDropData : IDDropDownData?
    
    @Published private(set) var Loading = false
    
    @Published var hasSiteArrayFound: Bool = false
    
    init() {
        checkIDDropData()
    }
    
    
    func checkIDDropData() {
        //        if arrActivity.count == 0 || arrRelation.count == 0 || arrSite.count == 0 || arrCheck.count == 0 || arrAttendance.count == 0 {
        //
        //        }
        if dicIDDropData == nil {
            getIDDropDataApi()
        }
    }
    
    
    func getIDDropDataApi() {
        self.Loading = true
        let url = URL(string: "https://apsreporting.com.au/api/User/drops_data")!
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
                if let idDropData = try? JSONDecoder().decode(InspectionDetailsDropDataWrapper.self, from: data) {
                    if idDropData.status == 1 {
                        self.dicIDDropData = idDropData.data
                        self.arrActivity = idDropData.data.activity
                        self.arrRelation = idDropData.data.relation
                        self.arrSite = idDropData.data.site
                        self.arrCheck = idDropData.data.check
                        self.arrAttendance = idDropData.data.attendance
                        self.Loading = false
                        
                        if self.arrSite.count != 0 {
                            self.hasSiteArrayFound = true
                        }
                    }
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
}
