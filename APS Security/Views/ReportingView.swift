//
//  ReportingView.swift
//  APS Security
//
//  Created by Vishal Patel on 27/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI
import CoreLocation
import MobileCoreServices
import Photos

struct ImageHeader: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        
        HStack {
            Text("Add Inspection Photos")
                .font(.system(size: 22))
            
            Spacer()
            
            Button(action: {
                self.showSheet.toggle()
                self.hideKeyboard()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }.padding(.trailing, 20)
        }
    }
}

class User: ObservableObject {
    @Published var loginUserName = ""
    @Published var shiftId = 0
    @Published var userId = "0"
    @Published var userData:LoginData?
    @Published var petrolId = "0"
    @Published var arrVehicleUnitList: [vehicleUnitList] = []
    @Published var arrVehiclePetrolArea: [vehiclePatrolArea] = []
    //    @Published var PetrolAreaList: [vehiclePatrolArea] = []
    //    @Published var VehicalUnitList: [vehicleUnitList] = []
    //
}

struct ReportingView: View {
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var user: User
    @ObservedObject var locationManager = LocationManager2()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var address: String {
        return "\(locationManager.address ?? "Not found")"
    }
    
    //@State var showReportingView = false
    @State var officerName = "Officer"
    @State var selPetrolArea = 0
    @State private var selVehicleUnitNum = 0
    @State private var selPetrolAreaID = ""
    @State private var selVehicleUnitNumID = ""
    
    @State private var startKm = ""
    
    @State private var checkList1 = false
    @State private var checkList2 = false
    @State private var checkList3 = false
    @State private var checkList4 = false
    @State private var checkList5 = false
    
    @State private var comments = ""
    
    
    @State var isViewActive: Bool = false
    
    @ObservedObject var PetrolAreaObserver = PetrolAreaListObserver()
    @ObservedObject var VehicalUnitListObserver = VehicalUnitObserver()
    @State var showSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var selected : [SelectedImages] = []
    @State var showLibraryPicker = false
    @State var value:CGFloat = 0
    @State var showLoadingIndicator: Bool = false
    @State var arrSelectedImageIDs : [Int] = []
    
    @ObservedObject var updatedDate = TimerHolder()
    @ObservedObject private var keyboard = KeyboardResponder()

    let formatter = DateFormatter()
    
    /*
     init(){
     UITableView.appearance().backgroundColor = .clear
     }
     */
    var body: some View {
    
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: Date())
        
        //print("Address: \(address)")
        //print("Officer name: \(user.loginUserName)")
        
        return ZStack{
            Form {
                HStack {
                    Text("Officer name")
                    Spacer()
                    Text("\(user.loginUserName)")
                        .foregroundColor(Color.gray)
                }
                
                if !PetrolAreaObserver.Loading{
                    
                    Picker(selection: $selPetrolArea , label: Text("Patrol Area")) {
                        ForEach(0 ..< PetrolAreaObserver.arrVehiclePetrolArea.count) { petrolAreaIndex in
                            Text(self.PetrolAreaObserver.arrVehiclePetrolArea[petrolAreaIndex].patrolAreaName)
                                .tag(petrolAreaIndex)
                        }
                    }.onReceive(PetrolAreaObserver.arrVehiclePetrolArea.publisher.first()) { value in
                        
                    }
                }
                
                HStack {
                    Text("Shift Start")
                    Spacer()
                    Text(dateString)
                        .foregroundColor(Color.gray)
                }
                
                if !VehicalUnitListObserver.Loading{
                    Picker(selection: $selVehicleUnitNum , label: Text("Vehicle Unit")) {
                        ForEach(0 ..< VehicalUnitListObserver.arrVehicleUnitList.count ) { unitListIndex in
                            Text(self.VehicalUnitListObserver.arrVehicleUnitList[unitListIndex].vehicleName)
                                .tag(unitListIndex)
                        }
                    }.onReceive(PetrolAreaObserver.arrVehiclePetrolArea.publisher.first()) { value in
                        
                    }
                }
                /*
                HStack {
                    Text("Start Location")
                    Spacer()
                    Text("\(userLatitude),\(userLongitude)")
                        .foregroundColor(Color.gray)
                }
                */

                HStack {
                    Text("Address")
                    Spacer()
                    Text("\(address)")
                        .foregroundColor(Color.gray)
                }
                
                Section(header: Text("Start km").font(.system(size: 18))) {
                    TextField("Enter start km here", text: $startKm){
                    }
                }
                
                Section(header: Text("Shift Start Checklist").font(.system(size: 22))) {
                    ChecklistView(isChecked: self.$checkList1, title: "Attended 15 minutes prior to the shift")
                    ChecklistView(isChecked: self.$checkList2, title: "Full Uniform On")
                    ChecklistView(isChecked: self.$checkList3, title: "All allocated equipment checked & working fine")
                    ChecklistView(isChecked: self.$checkList4, title: "Car in clean condition inside & outside")
                    ChecklistView(isChecked: self.$checkList5, title: "Car not damanaged inside & outside")
                }
                
                Section(header: Text("Comments").font(.system(size: 22))) {
                    
                    MultilineTextField("Enter comments here", text: self.$comments, onCommit: {
                        print("Final comments: \(self.comments)")
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
                    
                    
                    NavigationLink(destination: EnterSiteView(inspectionDate: dateString, user: self.user), isActive: self.$isViewActive) {
                        
                        Button(action: {
                    //        self.isViewActive = true
                            showLoadingIndicator = true
                            if self.selected.count > 0 {
                                self.apiCallReportingUploadImage()
                            }else{
                                self.apiCallShiftStart()
                            }
                        }) {
                            Text.init("Commence Patrols")
                                .font(.system(size: 25))
                                .fontWeight(.semibold)
                            
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                    }
                    .isDetailLink(false)
                    .onReceive(self.appState.$moveToReporting) { moveToReporting in
                        if moveToReporting {
                            print("MoveToReporting: \(moveToReporting)")
                            self.isViewActive = false
                            self.appState.moveToReporting = false
                            
                            self.selPetrolArea = 0
                            self.selVehicleUnitNum = 0
                            self.selPetrolAreaID = ""
                            self.selVehicleUnitNumID = ""
                            
                            self.startKm = ""
                            
                            self.checkList1 = false
                            self.checkList2 = false
                            self.checkList3 = false
                            self.checkList4 = false
                            self.checkList5 = false
                            
                            self.comments = ""
                            self.selected.removeAll()
                            self.arrSelectedImageIDs.removeAll()
                                                        
                        }
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
                CustomPicker(selected: self.$selected, show: self.$showLibraryPicker)
            }
            if self.showImagePicker{
                ImagePicker(selected: $selected, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
            if self.showLoadingIndicator{
                ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .gradient([.white, .red]))
                    .frame(width: 60.0, height: 60.0)
            }
        }
        .disabled(self.showLoadingIndicator)
        .padding(.bottom, keyboard.currentHeight)
        //.offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            if self.PetrolAreaObserver.arrVehiclePetrolArea.count == 0{
                self.PetrolAreaObserver.getPatrolAreaApi()
            }
            if self.VehicalUnitListObserver.arrVehicleUnitList.count == 0{
                self.VehicalUnitListObserver.getVehicleUnitApi()
            }
            /*
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.value = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                
                self.value = 0
            }
            */
        }
    }
    
    func apiCallReportingUploadImage(){
        
        var arrFilePath :[String] = []
        
        for data in selected{
            arrFilePath.append(data.path)
        }
        
        let arrFiles = [
            [MultiPart.fieldName: "files[]",
             MultiPart.pathURLs: arrFilePath]
        ]
        //https://apsreporting.com.au/api/User/insert_file
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
                self.apiCallShiftStart()
            case .failure(let failureResponse):
                self.showLoadingIndicator = false
                print(failureResponse.message ?? "")
            case .error(let e):
                self.showLoadingIndicator = false
                print(e ?? "")
            }
        }
    }
    
    func apiCallShiftStart(){
        if PetrolAreaObserver.arrVehiclePetrolArea.count > 0 {
            selPetrolAreaID = PetrolAreaObserver.arrVehiclePetrolArea[selPetrolArea].patrolID
        }
        if VehicalUnitListObserver.arrVehicleUnitList.count > 0 {
            selVehicleUnitNumID = VehicalUnitListObserver.arrVehicleUnitList[selVehicleUnitNum].vehicleID
        }
        var strUserid = "1"
        if let userId = self.user.userData?.userID{
            strUserid = userId
        }
        
        self.user.petrolId = selPetrolAreaID
        self.user.arrVehiclePetrolArea = PetrolAreaObserver.arrVehiclePetrolArea
        self.user.arrVehicleUnitList = VehicalUnitListObserver.arrVehicleUnitList
        
        let dateString = formatter.string(from: Date())
        
        let params = ["latitude": "\(userLatitude)" ,
                      "longitude":"\(userLongitude)",
                      "location":"\(address)",
                      "sc_start_cl_1":"\(checkList1 ? "true" : "false")",
                      "sc_start_cl_2":"\(checkList2 ? "true" : "false")",
                      "sc_start_cl_3":"\(checkList3 ? "true" : "false")",
                      "sc_start_cl_4":"\(checkList4 ? "true" : "false")",
                      "sc_start_cl_5":"\(checkList5 ? "true" : "false")",
                      "user_id":strUserid,
                      "patrol_id":"\(selPetrolAreaID)",
                      "shift_start_time":dateString,
                      "shift_vehicle_unit":"\(selVehicleUnitNumID)",
                      "shift_start_comments":"\(comments)",
                      "shift_start_km":"\(startKm)",
                      "image":arrSelectedImageIDs] as [String : Any]
        
        for (key, value) in params {
           print("** Reporting Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: "https://apsreporting.com.au/api/User/shiftStart", params: params, model: ShiftStartWrapper.self) {
            result in
            showLoadingIndicator = false
            switch result {
            case .success(let response):
                //print(response)
                self.user.shiftId = response.shift_id 
                self.isViewActive = true
                
                print("** ReportingView Response: \(response)")
            case .failure(let failureResponse):
                print(failureResponse.message ?? "")
            case .error(let e):
                print(e ?? "")
            }
        }
    }
}

class VehicalUnitObserver : ObservableObject{
    
    @Published var arrVehicleUnitList: [vehicleUnitList] = []
    @Published private(set) var Loading = false
    
    init() {
        checkForVehicleData()
    }
    
    func checkForVehicleData() {
        if arrVehicleUnitList.count == 0 {
            getVehicleUnitApi()
        }
    }
    
    func getVehicleUnitApi() {
        self.Loading = true
        let url = URL(string: "https://apsreporting.com.au/api/User/vehicle_unit")!
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
                    
                    print("vehicle unit status-> \(vehicleUnit.status)")
                    print("vehicle unit status-> \(vehicleUnit.message)")
                    print("vehicle unit count-> \(vehicleUnit.data.vehicleUnitList.count)")
                    self.arrVehicleUnitList = vehicleUnit.data.vehicleUnitList
                    
                    self.Loading = false
                    print("====\(self.arrVehicleUnitList)")
                    
                    
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
}

class PetrolAreaListObserver : ObservableObject{
    
    @Published var arrVehiclePetrolArea: [vehiclePatrolArea] = []
    @Published private(set) var Loading = false
    
    init() {
        checkForPetrolAreaList()
    }
    
    func checkForPetrolAreaList() {
        if arrVehiclePetrolArea.count == 0 {
            getPatrolAreaApi()
        }
    }
    
    func getPatrolAreaApi() {
        self.Loading = true
        let url = URL(string: "https://apsreporting.com.au/api/User/patrol_area")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            print("get petrol area: \(response)")
            
            DispatchQueue.main.async {
                if let petrolData = try? JSONDecoder().decode(PatrolAreaWrapper.self, from: data) {
                    
                    self.arrVehiclePetrolArea = petrolData.data.vehiclePatrolArea
                    self.Loading = false
                    print("====\(self.arrVehiclePetrolArea)")
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
}
