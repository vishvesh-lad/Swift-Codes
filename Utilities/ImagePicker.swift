//
//  ImagePicker.swift
//
//  Created by Vicky Prajapati.
//

import UIKit
import MobileCoreServices

//ImagePicker utility
class ImagePicker: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    //MARK:- Variables
    var picker=UIImagePickerController()
    
    //MARK:- Closures
    var handler:((UIImage, MediaContentType)->())?
    var handler1:((URL)->())?
    
    //MARK:- Initialization
    override init() {
        super.init()
        picker = UIImagePickerController.init()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    //Pick image from camera or photo library
    func pickImage(_ sender:Any, pickerHandler:@escaping(UIImage, MediaContentType)->())
    {
        handler = pickerHandler
        
        let actionSheet = UIAlertController.init(title: LanguageManager.localizedString("Select image source"), message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction.init(title: LanguageManager.localizedString("Take Photo"), style: .default) { (action) in
            self.takePhoto(sender, pickerHandler: pickerHandler)
        }
        let library = UIAlertAction.init(title: LanguageManager.localizedString("Choose Photo"), style: .default) { (action) in
            self.choosePhoto(sender, pickerHandler: pickerHandler)

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
    
    //Capture and return image from imagepicker
    func takePhoto(_ sender:Any, pickerHandler:@escaping(UIImage, MediaContentType)->())
    {
        handler = pickerHandler
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeImage as String]
            let VC = UIApplication.topViewController()
            VC?.present(picker, animated: true, completion: nil)
        }
    }
    
    //Capture Video from imagepicker and return Url
    func pickVideo(_ sender:Any, pickerHandler:@escaping(URL)->())
    {
        handler1 = pickerHandler
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            let VC = UIApplication.topViewController()
            VC?.present(picker, animated: true, completion: nil)
        }
    }
    
    //Choose photo from library and return image
    func choosePhoto(_ sender:Any, pickerHandler:@escaping(UIImage, MediaContentType)->())
    {
        
        handler = pickerHandler
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeImage as String]
            let VC = UIApplication.topViewController()
            VC?.present(picker, animated: true, completion: nil)
        }
    }
    
    //MARK:- ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //Check media type image or video
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picker.dismiss(animated: true) {
                if (self.handler != nil){
                    var imageType: MediaContentType = .ImageJPEG
                    if let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL {
                        if (assetPath.absoluteString?.hasSuffix("PNG"))! {
                            imageType = MediaContentType.ImagePNG
                        }
                    }
                    //let imgData = Data(UIImageJPEGRepresentation((image), 1)!)
                    //let imageSize = imgData.count / 1024 // kb Size
                    //print("Origial Image Size : %d kb",imageSize)
                    if let data = image.jpegData(compressionQuality: JPEGQuality.medium.rawValue){
                        if let compressImage = UIImage(data: data) {
                            self.handler!(compressImage, imageType)
                        }
                    }
                }
            }
        } else {
            picker.dismiss(animated: true) {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                if (self.handler1 != nil){
                    self.handler1!(videoURL)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
}
