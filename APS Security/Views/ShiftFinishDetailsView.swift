
import SwiftUI

struct ShiftFinishDetailsView: View {
    
    @EnvironmentObject var appState: AppState

    @State private var officerName = "Officer"
    @State private var selPetrolArea = 0
    @State private var selVehicleUnitNum = 12
    @State private var selPetrolAreaId = ""
    @State private var selVehicleUnitID = 12
    
    @State private var startKm = ""
    
    @State private var checkList1 = true
    @State private var checkList2 = false
    @State private var checkList3 = false
    @State private var checkList4 = false
    @State private var checkList5 = false
    @State private var checkList6 = false
    @State private var checkList7 = false
    @State private var checkList8 = false
    
    @State private var comments = ""
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    /*
     init(){
     UITableView.appearance().backgroundColor = .clear
     }
     */
    //Image Data
    @State var showSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var selected : [ShiftFinishSelectedImages] = []
    @State var showLibraryPicker = false
    @State var value:CGFloat = 0
    @State var showLoadingIndicator: Bool = false
    @State var arrSelectedImageIDs : [Int] = []
    
    @ObservedObject var user: User
    @ObservedObject var updatedDate = TimerHolder()
    @ObservedObject var locationManager = LocationManager2()
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
    
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        let dateString = formatter.string(from: Date())
        
        print("Shift Finish petrolArea counts:\(user.arrVehiclePetrolArea.count)")
        return ZStack{
            Form {
                
                HStack {
                    Text("Officer name")
                    Spacer()
                    Text("\(officerName)")
                        .foregroundColor(Color.gray)
                }
                
                Picker("Patrol Area", selection: $selPetrolArea) {
                    
                    ForEach(0 ..< user.arrVehiclePetrolArea.count) { petrolAreaIndex in
                        Text(self.user.arrVehiclePetrolArea[petrolAreaIndex].patrolAreaName)
                            .tag(petrolAreaIndex)
                    }
                }
                .onReceive(user.arrVehiclePetrolArea.publisher.first()) { value in
                    
                }
                
                
                
                HStack {
                    Text("Shift Finish")
                    Spacer()
                    Text(dateString)
                        .foregroundColor(Color.gray)
                }
                
                Picker("Vehicle Unit", selection: $selVehicleUnitNum) {
                    ForEach(0 ..< user.arrVehicleUnitList.count ) { unitListIndex in
                        Text(user.arrVehicleUnitList[unitListIndex].vehicleName)
                            .tag(unitListIndex)
                    }
                }
                
                HStack {
                    Text("Address")
                    Spacer()
                    Text("\(address)")
                        .foregroundColor(Color.gray)
                }
                
                
                Section(header: Text("Finish km").font(.system(size: 18))) {
                    TextField("Enter finish km here", text: $startKm)
                }
                
                Section(header: Text("Shift Completion Checklist").font(.system(size: 22))) {
                    ChecklistView(isChecked: self.$checkList1, title: "I can confirm below")
                    ChecklistView(isChecked: self.$checkList2, title: "I have completed my shift as per the allocated roster schedule")
                    ChecklistView(isChecked: self.$checkList3, title: "All details provided are true & correct")
                    ChecklistView(isChecked: self.$checkList4, title: "I can confirm no damage to the work car inside & outside")
                    ChecklistView(isChecked: self.$checkList5, title: "I can confirm the work car to be clean condition inside & outside")
                    ChecklistView(isChecked: self.$checkList6, title: "I can confirm the work car inspected properly & is in safe condition")
                    ChecklistView(isChecked: self.$checkList7, title: "I can confirm having full uniform throughout my shift")
                    ChecklistView(isChecked: self.$checkList8, title: "I can confirm no damage to the allocated equipment")
                    
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
                    
                    Button(action: {
                        showLoadingIndicator = true
                        if self.selected.count > 0 {
                            self.apiCallShiftFinishUploadImage()
                        }else{
                            self.apiCallShiftFinish()
                        }
                    }) {
                        Text.init("Conclude Shift")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                        
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    /*
                     NavigationLink(destination: ExitSite(), tag : true, selection: self.$gotoNextView) {
                     Text("")
                     }
                     */
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
                ShiftFinishCustomPicker(selected: self.$selected, show: self.$showLibraryPicker)
            }
            if self.showImagePicker{
                ShiftFinishImageImagePicker(selected: $selected, isShown: self.$showImagePicker, sourceType: self.sourceType)
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
        .navigationBarTitle("Shift Finish Details")
    }
    
    func apiCallShiftFinishUploadImage(){
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
                self.apiCallShiftFinish()
            case .failure(let failureResponse):
                showLoadingIndicator = false
                print(failureResponse.message ?? "")
            case .error(let e):
                showLoadingIndicator = false
                print(e ?? "")
            }
        }
    }
    
    func apiCallShiftFinish(){
        
        let params = [ "shift_id": self.user.shiftId,
                       "fc_finish_cl_1":"\(checkList1 ? "true" : "false")",
                       "fc_finish_cl_2":"\(checkList2 ? "true" : "false")",
                       "fc_finish_cl_3":"\(checkList3 ? "true" : "false")",
                       "fc_finish_cl_4":"\(checkList4 ? "true" : "false")",
                       "fc_finish_cl_5":"\(checkList5 ? "true" : "false")",
                       "fc_finish_cl_6":"\(checkList6 ? "true" : "false")",
                       "fc_finish_cl_7":"\(checkList7 ? "true" : "false")",
                       "latitude":userLatitude,
                       "longitude":userLongitude,
                       "fulladdress":address,
                       "shift_finish_km":"\(startKm)",
                       "shift_finish_time":updatedDate.newDate,
                       "shift_end_img_id":arrSelectedImageIDs] as [String : Any]
        
        for (key, value) in params {
           print("** ShiftFinish Key:(\(key),Value: \(value))")
        }
        
        ApiCall().post(apiUrl: "https://apsreporting.com.au/api/User/endShift", params: params, model: EndShiftWrapper.self) {
            result in
            
            DispatchQueue.main.async {
                showLoadingIndicator = false
                switch result {
                case .success(let response):
                    //print(response)
                    self.appState.moveToReporting = true
                    
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
