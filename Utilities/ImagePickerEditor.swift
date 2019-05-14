//
//  ImagePickerEditor.swift
//
//  Created by Vicky Prajapati.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

enum ImagerPickerEnum{
    case TakePhoto
    case ChoosePhoto
    case TakeVideo
    case ChooseVideo
    case SectionMedia
    case ChooseReportVideo
}

enum AskMediaPickerOptionsEnum{
    case PhotoOptions
    case VideoOptions
    case TakePhoto
    case TakeVideo
    case ChooseVideo
    case GalleryOptions
    case CameraOptions
    case AllOptions
}

enum ImageEditorModeEnum{
    case PushToCaptionVC
    case AppearFromCaptionVC
    case DoNotShowCaptionVC
}

enum AddCommentTypeEnum{
    case Manually
    case ChooseComment
}

let maxImageLimit = 10
let maxVideoLimit = 1
let maxReportVideoLimit = 5
let videoDurationLimit = 90.00

class ImagePickerEditor: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate, IQMediaPickerControllerDelegate, ImageViewerCaptionProtocol, SectionMediaPickerProtocol {
    
    //Shared Instance class
    static let sharedInstance = ImagePickerEditor()
    
    //MARK:- Variables
    var IQImagePicker: IQMediaPickerController?
    var arrImageTuple = [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)]()
    var maxMediaAllowed : Int = maxImageLimit
    var objImagerPickerEnum: ImagerPickerEnum?
    var isAskForCommentType: Bool = false
    
    //Video Picker
//    var defaultPicker = UIImagePickerController()
    var mediaType: MediaContentType?
    
    //MARK:- Closures
    var handler:((_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->())?
    var imageCaptionHandler:((_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->())?
    var sectionMediaPickerHandler: ((_ arrSectionMedia: [Section_Media]?) -> ())?
    var imageEditorModeEnum: ImageEditorModeEnum?
    
    //Pass Values
    var objItem_Comment:Item_Comment?
    var objTemplateSection: Template_Section?
    
    //MARK:- Initialization
    override init() {
        super.init()
    }
    
    // MARK: - Photos Permission
    func checkIfAuthorizedToAccessPhotos(_ handler: @escaping (_ isAuthorized: Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        handler(true)
                    default:
                        handler(false)
                    }
                }
            }
        case .restricted:
            handler(false)
        case .denied:
            handler(false)
        case .authorized:
            handler(true)
        }
    }
    
    //Pick image from camera or photo library
    func showPickMediaOptions(_ sender:Any, objItem_Comment:Item_Comment?, objTemplateSection: Template_Section?, isAskForCommentType: Bool, imageEditorModeEnum: ImageEditorModeEnum?, objAskMediaPickerOptionsEnum: AskMediaPickerOptionsEnum?, maxImageLimit:Int = maxImageLimit, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)],_ objAddCommentTypeEnum: AddCommentTypeEnum?)->(), sectionMediaPickerHandler: @escaping(_ arrSectionMedia: [Section_Media]?) -> ())
    {
        if AWSS3Manager.sharedInstance.checkDeviceFreeSpaceAvailable() == false{
            return
        }
        
        self.handler = pickerHandler
        self.sectionMediaPickerHandler = sectionMediaPickerHandler
        self.objItem_Comment = objItem_Comment
        self.objTemplateSection = objTemplateSection
        self.imageEditorModeEnum = imageEditorModeEnum
        arrImageTuple = [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)]()
        maxMediaAllowed = maxImageLimit
        self.isAskForCommentType = isAskForCommentType
        
        let actionSheet = UIAlertController.init(title: LanguageManager.localizedString("Select Media source"), message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction.init(title: LanguageManager.localizedString("Take Photo"), style: .default) { (action) in
            self.objImagerPickerEnum = ImagerPickerEnum.TakePhoto
            self.takePhoto(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
        }
        //Choose Photo From Gallery
        let choosePhoto = UIAlertAction.init(title: LanguageManager.localizedString("Choose Photo"), style: .default) { (action) in
            self.objImagerPickerEnum = ImagerPickerEnum.ChoosePhoto
            self.takePhotoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
        }
        let recordVideo = UIAlertAction.init(title: LanguageManager.localizedString("Record Video"), style: .default) { (action) in
            self.objImagerPickerEnum = ImagerPickerEnum.TakeVideo
            self.recordVideo(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
        }
        //Choose Video From Gallery
        let chooseVideo = UIAlertAction.init(title: LanguageManager.localizedString("Choose Video"), style: .default) { (action) in
            self.objImagerPickerEnum = ImagerPickerEnum.ChooseVideo
            self.chooseVideoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
        }
        let chooseSectionMedia = UIAlertAction.init(title: LanguageManager.localizedString("Choose Media From Photo Storage"), style: .default) { (action) in
            self.objImagerPickerEnum = ImagerPickerEnum.SectionMedia
            self.chooseSectionMedia(sender)
        }
        let cancel = UIAlertAction.init(title: LanguageManager.localizedString("Cancel"), style: .cancel) { (action) in
        }
        
        if let popoverController = actionSheet.popoverPresentationController {
            if let view = sender as? UIView
            {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
            }
        }
        
        if let objAskMediaPickerOptionsEnum = objAskMediaPickerOptionsEnum{
            switch(objAskMediaPickerOptionsEnum){
            case .PhotoOptions:
                actionSheet.addAction(takePhoto)
                actionSheet.addAction(choosePhoto)
                if objTemplateSection != nil{
                    actionSheet.addAction(chooseSectionMedia)
                }
                actionSheet.addAction(cancel)
                let VC = UIApplication.topViewController()
                VC?.present(actionSheet, animated: true, completion: nil)
                break
            case .VideoOptions:
                actionSheet.addAction(recordVideo)
                actionSheet.addAction(chooseVideo)
                if objTemplateSection != nil{
                    actionSheet.addAction(chooseSectionMedia)
                }
                actionSheet.addAction(cancel)
                let VC = UIApplication.topViewController()
                VC?.present(actionSheet, animated: true, completion: nil)
                break
            case .TakePhoto:
                self.objImagerPickerEnum = ImagerPickerEnum.TakePhoto
                self.takePhoto(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
                break
            case .TakeVideo:
                self.objImagerPickerEnum = ImagerPickerEnum.TakeVideo
                self.recordVideo(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
                break
            case .ChooseVideo:
                self.objImagerPickerEnum = ImagerPickerEnum.ChooseReportVideo
                self.chooseVideoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: false)
                break
            case .CameraOptions:
                actionSheet.addAction(takePhoto)
                actionSheet.addAction(recordVideo)
                if objTemplateSection != nil{
                    actionSheet.addAction(chooseSectionMedia)
                }
                actionSheet.addAction(cancel)
                let VC = UIApplication.topViewController()
                VC?.present(actionSheet, animated: true, completion: nil)
                break
            case .GalleryOptions:
                actionSheet.addAction(choosePhoto)
                actionSheet.addAction(chooseVideo)
                if objTemplateSection != nil{
                    actionSheet.addAction(chooseSectionMedia)
                }
                actionSheet.addAction(cancel)
                let VC = UIApplication.topViewController()
                VC?.present(actionSheet, animated: true, completion: nil)
                break
            case .AllOptions:
                actionSheet.addAction(takePhoto)
                actionSheet.addAction(choosePhoto)
                actionSheet.addAction(recordVideo)
                actionSheet.addAction(chooseVideo)
                if objTemplateSection != nil{
                    actionSheet.addAction(chooseSectionMedia)
                }
                actionSheet.addAction(cancel)
                let VC = UIApplication.topViewController()
                VC?.present(actionSheet, animated: true, completion: nil)
                break
            }
        }
    }
    
    func pickMediaForImagePickerType(_ sender:Any, objImagerPickerEnum: ImagerPickerEnum?, maxMediaAllowed:Int, objItem_Comment:Item_Comment?, imageEditorModeEnum: ImageEditorModeEnum?, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->()){
        
        if AWSS3Manager.sharedInstance.checkDeviceFreeSpaceAvailable() == false{
            return
        }
        
        arrImageTuple = [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)]()
        imageCaptionHandler = pickerHandler
        self.imageEditorModeEnum = imageEditorModeEnum
        self.maxMediaAllowed = maxMediaAllowed
        
        if let objImagePickerEnum = objImagerPickerEnum{
            switch(objImagePickerEnum){
            case .TakePhoto:
                self.takePhoto(sender, pickerHandler: pickerHandler, isImageCaptionHandler: true)
                break
            case .ChoosePhoto:
                self.takePhotoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: true)
                break
            case .TakeVideo:
                self.recordVideo(sender, pickerHandler: pickerHandler, isImageCaptionHandler: true)
                break
            case .ChooseVideo:
                self.chooseVideoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: true)
                break
            case .SectionMedia:
                break
	    case .ChooseReportVideo:
                self.chooseVideoFromGallery(sender, pickerHandler: pickerHandler, isImageCaptionHandler: true)
                break
            }
        }
    }
    
    //Capture and return image from imagepicker
    func takePhoto(_ sender:Any, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->(), isImageCaptionHandler: Bool)
    {
        if isImageCaptionHandler{
            imageCaptionHandler = pickerHandler
        }else{
            handler = pickerHandler
        }
        
        IQImagePicker = IQMediaPickerController()
        IQImagePicker?.delegate = self
        IQImagePicker?.sourceType = .cameraMicrophone
        IQImagePicker?.mediaTypes = [IQMediaPickerControllerMediaType.photo.rawValue] as [NSNumber]
        IQImagePicker?.allowedVideoQualities = [IQMediaPickerControllerQualityType.type1280x720.rawValue] as [NSNumber]
        var flashMode = 2 //Auto
        if UserDefaults.standard.object(forKey: AppConstant.DataModelKey.kCameraFlashState) != nil{
            flashMode = UserDefaults.standard.integer(forKey: AppConstant.DataModelKey.kCameraFlashState)
        }
        IQImagePicker?.flashMode = IQMediaPickerControllerCameraFlashMode.init(rawValue: flashMode) ?? .auto
        IQImagePicker?.allowsPickingMultipleItems = true
        IQImagePicker?.maximumItemCount = UInt(maxMediaAllowed)
        let VC = UIApplication.topViewController()
        VC?.present(IQImagePicker!, animated: true, completion: nil)
    }
    
    //Choose photo from library and return image
    func takePhotoFromGallery(_ sender:Any, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->(), isImageCaptionHandler: Bool)
    {
        checkIfAuthorizedToAccessPhotos { isAuthorized in
            DispatchQueue.main.async(execute: {
                if isAuthorized {
                    if isImageCaptionHandler{
                        self.imageCaptionHandler = pickerHandler
                    }else{
                        self.handler = pickerHandler
                    }
                    
                    self.IQImagePicker = IQMediaPickerController()
                    self.IQImagePicker?.delegate = self
                    self.IQImagePicker?.sourceType = .library
                    self.IQImagePicker?.mediaTypes = [IQMediaPickerControllerMediaType.photo.rawValue] as [NSNumber]
                    self.IQImagePicker?.allowsPickingMultipleItems = true
                    self.IQImagePicker?.maximumItemCount = UInt(self.maxMediaAllowed)
                    let VC = UIApplication.topViewController()
                    VC?.present(self.IQImagePicker!, animated: true, completion: nil)
                } else {
                    Utilities.showCustomToast(message: "Denied access to photos.")
                }
            })
        }
    }
    
    //Capture and return Video from imagepicker
    func recordVideo(_ sender:Any, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->(), isImageCaptionHandler: Bool)
    {
        if isImageCaptionHandler{
            imageCaptionHandler = pickerHandler
        }else{
            handler = pickerHandler
        }
        
        IQImagePicker = IQMediaPickerController()
        IQImagePicker?.delegate = self
        IQImagePicker?.sourceType = .cameraMicrophone
        IQImagePicker?.mediaTypes = [IQMediaPickerControllerMediaType.video.rawValue] as [NSNumber]
        IQImagePicker?.allowedVideoQualities = [IQMediaPickerControllerQualityType.typeMedium.rawValue] as [NSNumber]
        IQImagePicker?.videoMaximumDuration = videoDurationLimit
        IQImagePicker?.allowsPickingMultipleItems = false
        IQImagePicker?.maximumItemCount = 1//UInt(maxMediaAllowed)
        let VC = UIApplication.topViewController()
        VC?.present(IQImagePicker!, animated: true, completion: nil)
    }
    
    //Choose Video from library and return image
    func chooseVideoFromGallery(_ sender:Any, pickerHandler:@escaping(_ arrImageTuple : [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], _ objAddCommentTypeEnum: AddCommentTypeEnum?)->(), isImageCaptionHandler: Bool)
    {
        if isImageCaptionHandler{
            imageCaptionHandler = pickerHandler
        }else{
            handler = pickerHandler
        }
        
        IQImagePicker = IQMediaPickerController()
        IQImagePicker?.delegate = self
        IQImagePicker?.sourceType = .library
        IQImagePicker?.mediaTypes = [IQMediaPickerControllerMediaType.video.rawValue] as [NSNumber]
        if self.objImagerPickerEnum == ImagerPickerEnum.ChooseReportVideo{
            IQImagePicker?.maximumItemCount = UInt(maxMediaAllowed)
            IQImagePicker?.allowsPickingMultipleItems = true
        }else{
            IQImagePicker?.videoMaximumDuration = videoDurationLimit
            IQImagePicker?.maximumItemCount = 1 //UInt(maxMediaAllowed)
            IQImagePicker?.allowsPickingMultipleItems = false
        }
	
        let VC = UIApplication.topViewController()
        VC?.present(IQImagePicker!, animated: true, completion: nil)
    }
    
    //Choose Video from Section media
    func chooseSectionMedia(_ sender:Any)
    {
        let storyboard = UIStoryboard(name: StoryBoardIdentifier.SectionsStoryBoard, bundle: nil)
        let objImageStoragePickerVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ImageStoragePickerVC) as! ImageStoragePickerVC
        objImageStoragePickerVC.objTemplateSection = self.objTemplateSection
        objImageStoragePickerVC.delegate = self
        
//        ((UIApplication.topViewController() as? REFrostedViewController)?.contentViewController as? UINavigationController)?
        let VC = UIApplication.topViewController()
        VC?.present(objImageStoragePickerVC, animated: true, completion: nil)
    }
    
    //MARK: SectionMediaPickerProtocol Methods
    func didCompletePickingSectionMedia(_ arrSectionMedia: [Section_Media]?) {
        self.sectionMediaPickerHandler!(arrSectionMedia)
    }
    
    //MARK: IQMediaPickerControllerDelegate
    func mediaPickerController(_ controller: IQMediaPickerController, didFinishMediaWithInfo info: [AnyHashable : Any]) {
        print(info)
        //Check media type image or video
        if let arrInfo = info[IQMediaTypeImage] as? [[String: Any]]{
            for objInfo in arrInfo{
                if let iqMediaImage = objInfo[IQMediaImage] as? UIImage{
                    self.arrImageTuple.append((iqMediaImage, "", "", .ImageJPEG))
                }else if let iqMediaURL = (objInfo[IQMediaURL] as? URL)?.absoluteString{
                    self.arrImageTuple.append((nil, iqMediaURL, "", .ImageJPEG))
                }
            }
            if arrImageTuple.count > 0{
                self.storeImageInDocumentDirectory(success: { [unowned self] in
                    self.IQImagePicker = nil
                    self.navigateToImagePreview()
                })
            }else{
                Utilities.showCustomToast(message: "iCloud media not supported.")
            }
        }else if let arrInfo = info[IQMediaTypeVideo] as? [[String: Any]]{
            for i in 0..<arrInfo.count{
                let objInfo = arrInfo[i]
                // Code Compress
                var videoAssetURL: URL?
                if let assetURL = objInfo[IQMediaURL] as? URL{
                    videoAssetURL = assetURL
                }else if let assetURL = objInfo[IQMediaAssetURL] as? URL{
                    videoAssetURL = assetURL
                }
                
                if let videoURL = videoAssetURL{
                    let asset = AVURLAsset(url: videoURL)
                    let videoDurationTime:Int = Int(asset.duration.seconds)
                    // Allow to choose only 90 sec video
                    if self.objImagerPickerEnum == ImagerPickerEnum.ChooseVideo && videoDurationTime > Int(videoDurationLimit) {
                        let alert = UIAlertController(title: "", message: "Please choose video less than 90 seconds.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        let VC = UIApplication.topViewController()
                        VC?.present(alert, animated: true, completion: nil)
                    }else{
                        self.mediaType =  String(describing: videoURL).MediaContentType()
                        if let mediaType = self.mediaType{
                            if (self.handler != nil){
                                let videoURLString = String(describing: videoURL)
                                let image = AWSS3Manager.sharedInstance.thumbnailForVideofile(str: videoURLString)
                                self.arrImageTuple.append((image, videoURLString, "", mediaType))
                                if i == (arrInfo.count - 1){
                                    self.IQImagePicker = nil
                                    self.navigateToImagePreview()
                                }
                            }
                        }
                    }
                }else{
                    Utilities.showCustomToast(message: "iCloud media not supported.")
                }
            }
        }
    }
    
    func mediaPickerControllerDidCancel(_ controller: IQMediaPickerController) {
        IQImagePicker = nil
    }
    
    //MARK: ImageViewerCaptionProtocol delegate
    func editingCompletedWith(arrImageTuple: [(image: UIImage?, mediaURL: String, caption: String, mediaContentType: MediaContentType)], objAddCommentTypeEnum: AddCommentTypeEnum?) {
        self.filterMediafailedToStoreInDocumentDir()
        self.handler!(arrImageTuple, objAddCommentTypeEnum)
    }
    
    //MARK: Navigate
    func navigateToImagePreview(){
        self.filterMediafailedToStoreInDocumentDir()
        
        if let imageEditorModeEnum = imageEditorModeEnum{
            switch (imageEditorModeEnum){
            case .PushToCaptionVC:
                let storyboard = UIStoryboard(name: StoryBoardIdentifier.ImageEditorStoryBoard, bundle: nil)
                let objImageViewerCaptionVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ImageViewerCaptionVC) as! ImageViewerCaptionVC
                objImageViewerCaptionVC.arrImageTuple = self.arrImageTuple
                objImageViewerCaptionVC.objItem_Comment = self.objItem_Comment
                objImageViewerCaptionVC.objImagerPickerEnum = self.objImagerPickerEnum
                objImageViewerCaptionVC.isAskForCommentType = self.isAskForCommentType
                
                objImageViewerCaptionVC.delegate = self
                
                let VC = UIApplication.topViewController()
                VC?.present(objImageViewerCaptionVC, animated: false, completion: nil)
                break
            case .AppearFromCaptionVC:
                //Return
                self.imageCaptionHandler!(arrImageTuple, nil)
                break
            case .DoNotShowCaptionVC:
                self.handler!(arrImageTuple, nil)
                break
            }
        }
    }
    
    func filterMediafailedToStoreInDocumentDir() {
        let arrFilteredImageTuple = self.arrImageTuple.filter({ $0.mediaURL != "" })
        self.arrImageTuple = arrFilteredImageTuple
    }
    
    // MARK:- Store Images
    func storeImageInDocumentDirectory(success withResponse: @escaping () -> ()){
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Your code with delay
            self.storeImage(index: 0, success: {
                SVProgressHUD.dismiss()
                withResponse()
            })
        }
    }
    
    func storeImage(index: Int, success withResponse: @escaping () -> ()){
        if index < self.arrImageTuple.count{
//            if self.arrImageTuple[index].mediaURL != ""{
                switch (self.arrImageTuple[index].mediaContentType){
                    
                case .ImageJPEG,.ImagePNG:
                    //Create Upload Media content object
                    if let image = self.arrImageTuple[index].image {
                        AWSS3Manager.sharedInstance.saveImageInDocumentDirectoryPath(image: image, imageDocDirPath: self.arrImageTuple[index].mediaURL, mediaContentType: arrImageTuple[index].mediaContentType, mediaURL: self.arrImageTuple[index].mediaURL, isCompress: true, completion: { [unowned self] (documentDirectoryUrl) in
                            self.arrImageTuple[index].mediaURL = documentDirectoryUrl ?? ""
                            
                            if (index + 1) < self.arrImageTuple.count{
                                self.storeImage(index: index + 1, success: {
                                    withResponse()
                                })
                            }else{
                                withResponse()
                            }
                        })
                    }else{
                        withResponse()
                    }
                    break
                default :
                    break
                }
//            }
        }
    }
}
