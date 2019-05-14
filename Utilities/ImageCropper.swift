//
//  ImageCropper.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

class ImageCropper : NSObject ,UIImageCropperProtocol {
    
    // MARK:- Variables
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 5/3)
    
    //MARK:- Closures
    var handler:((UIImage, MediaContentType)->())?
    
    //MARK:- Initialization
    override init() {
        super.init()
        //setup the cropper
        cropper.picker = picker
        cropper.delegate = self
//        cropper.cropRatio = 3/2 //(can be set during runtime or in init)
        cropper.cropButtonText = "Crop" // this can be localized if needed (as well as the cancelButtonText)
    }
    
    //Pick crop image from camera or photo library
    func pickCropImage(_ sender:Any, pickerHandler:@escaping(UIImage, MediaContentType)->()){
        
        if AWSS3Manager.sharedInstance.checkDeviceFreeSpaceAvailable() == false{
            return
        }
        
        handler = pickerHandler
        
        cropper.cancelButtonText = "Retake"
        
        let actionSheet = UIAlertController.init(title: LanguageManager.localizedString("Select image source"), message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction.init(title: LanguageManager.localizedString("Take Photo"), style: .default) { (action) in
            self.picker.sourceType = .camera
            let VC = UIApplication.topViewController()
            VC?.present(self.picker, animated: true, completion: nil)
        }
        let library = UIAlertAction.init(title: LanguageManager.localizedString("Choose Photo"), style: .default) { (action) in
            self.picker.sourceType = .photoLibrary
            let VC = UIApplication.topViewController()
            VC?.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction.init(title: LanguageManager.localizedString("Cancel"), style: .cancel) { (action) in
            
        }
        
        actionSheet.addAction(camera)
        actionSheet.addAction(library)
        actionSheet.addAction(cancel)
        
        let VC = UIApplication.topViewController()
        if let popoverController = actionSheet.popoverPresentationController {
           if let view = sender as? UIView
           {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
           }
            
        }
        VC?.present(actionSheet, animated: true, completion: nil)
    }
    
    // delegate methods
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?, assetUrl: NSURL?) {
        var imageType: MediaContentType = .ImageJPEG
        if let assetPath = assetUrl {
            if (assetPath.absoluteString?.hasSuffix("PNG"))! {
                imageType = MediaContentType.ImagePNG
            }
        }
        if let image = croppedImage{
            self.handler!(image,imageType)
        }
    }
}
