

import SwiftUI
import Photos

struct InspectionCustomPicker : View {
    
    @Binding var selected : [InspectionSelectedImages]
    @State var grid : [[InspectionImages]] = []
    @Binding var show : Bool
    @State var disabled = false

    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                
                if !self.grid.isEmpty{
                    
                    HStack{
                        
                        Text("Pick a Image")
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 20){
                            
                            ForEach(self.grid,id: \.self){i in
                                
                                HStack{
                                    
                                    ForEach(i,id: \.self){j in
                                        
                                        InspectionCard(data: j, selected: self.$selected)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    Button(action: {
                        
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Select")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color.red.opacity((self.selected.count != 0) ? 1 : 0.5))
                    .clipShape(Capsule())
                    .padding(.bottom)
                    .disabled((self.selected.count != 0) ? false : true)
                    
                }
                else{
                    
                    if self.disabled{
                        
                        Text("Enable Storage Access In Settings !!!")
                    }
                    if self.grid.count == 0{
                        
                        InspectionIndicator()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height / 1.5, alignment: .center)
            .background(Color.white)
            .cornerRadius(12)
        }
        .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.show.toggle()
                        })
        .onAppear {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized{
                    
                    self.getAllImages()
                    self.disabled = false
                }
                else{
                    
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){
        
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            // New Method For Generating Grid Without Refreshing....
            
            for i in stride(from: 0, to: req.count, by: 3){
                
                var iteration : [InspectionImages] = []
                
                for j in i..<i+3{
                    
                    if j < req.count{
                        
                        PHCachingImageManager.default().requestImage(for: req[j], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in
                            
                            guard let image = image else {
                                return
                            }

                                if let item = self.selected.filter({ $0.asset ==  req[j] }).first {
                                    let data1 = InspectionImages(image: image, selected: true, asset: req[j])
                                    iteration.append(data1)
                                }else{
                                    let data1 = InspectionImages(image: image, selected: false, asset: req[j])
                                    iteration.append(data1)
                                }
                        }
                    }
                }
                
                self.grid.append(iteration)
            }
            
        }
    }
}

struct InspectionCard : View {
    
    @State var data : InspectionImages
    @Binding var selected : [InspectionSelectedImages]

    var body: some View{
        
        ZStack{
            Image(uiImage: self.data.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            if self.data.selected{
                ZStack{
                    
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture {
            
            
            if !self.data.selected{
                
                
                self.data.selected = true
                
                // Extracting Orginal Size of Image from Asset
                
                DispatchQueue.global(qos: .background).async {
                    
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    
                    // You can give your own Image size by replacing .init() to CGSize....
                    
                    PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                        
                        self.data.asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                            if let input = eidtingInput, let photoUrl = input.fullSizeImageURL {
                                self.selected.append(InspectionSelectedImages(asset: self.data.asset, image: image!, path: photoUrl.path))
                            }
                        }
                    }
                }
                
            }
            else{
                
                for i in 0..<self.selected.count{
                    if self.selected[i].asset == self.data.asset{
                        self.selected.remove(at: i)
                        self.data.selected = false
                        return
                    }
                }
            }
        }
        
    }
}

struct InspectionIndicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView  {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
        
        
    }
}

struct InspectionImages: Hashable {
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct InspectionSelectedImages: Hashable{
    var asset : PHAsset
    var image : UIImage
    var path : String
}

class InspectionImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var selected : [InspectionSelectedImages]
    @Binding var isShown: Bool
    
    init(selected: Binding<[InspectionSelectedImages]>, isShown: Binding<Bool>) {
        _selected = selected
        _isShown = isShown
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var placeholder: PHObjectPlaceholder?
        var changeRequest: PHAssetChangeRequest?
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
            PHPhotoLibrary.shared().performChanges({
                changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                placeholder = changeRequest?.placeholderForCreatedAsset
            }, completionHandler: { success, error in
                if success {
                    let fetchOptions = PHFetchOptions()
                    let fetchResult:PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder!.localIdentifier], options: fetchOptions)
                    if let asset = fetchResult.firstObject {
                        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                            if let input = eidtingInput, let photoUrl = input.fullSizeImageURL {
                                self.selected.append(InspectionSelectedImages(asset: asset, image: uiImage, path: photoUrl.path))
                            }
                        }
                    }
                }
                else if let error = error {
                    // Save photo failed with error
                }
                else {
                    // Save photo failed with no error
                }
            })
            isShown = false
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
}

struct InspectionImageImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = InspectionImagePickerCoordinator
    
    @Binding var selected : [InspectionSelectedImages]
    @Binding var isShown: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<InspectionImageImagePicker>) {
    }
    
    func makeCoordinator() -> InspectionImageImagePicker.Coordinator {
        return InspectionImagePickerCoordinator(selected: $selected , isShown: $isShown)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<InspectionImageImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
        
    }
    
}

