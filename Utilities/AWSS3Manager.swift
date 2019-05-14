//
//  AWSS3Manager.swift
//
//  Created by Vicky Prajapati.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos

enum MediaContentType : String{
    case ImageJPEG = "image/jpeg"
    case ImagePNG = "image/png"
    case AudioM4A = "audio/m4a"
    case VideoMOV = "video/quicktime"
    case VideoMP4 = "video/mp4"
    case LogTxt = "file/txt"
    case SqliteDB = "file/sqlite"
}

enum AWSBucket{
    case Bucket1,
    Bucket2,
    Bucket3
    
    var rawValue:String {
        get {
            switch(self){
            case .Bucket1:
                return "\(Environment().configuration(PlistKey.AWSS3BucketName))/Bucket1"
            case .Bucket2:
                return "\(Environment().configuration(PlistKey.AWSS3BucketName))/Bucket2"
            case .Bucket3:
                return "\(Environment().configuration(PlistKey.AWSS3BucketName))/Bucket3"
            }
        }
    }
}

class AWSS3Manager: NSObject{
    
    // MARK: -  Variables
    // AWS S3 Bucket keys
    let accessKey = //kBucketAccessKey
    let secretKey = //kBucketSecretKey
    
    //Shared Instance class
    static let sharedInstance = AWSS3Manager()
    
    override init() {
        super.init()
        // AWS Bucket Configurations
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USWest2, endpoint: AWSEndpoint(url: URL(string: /*kAWSEndPointURL*/)), credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
   
    //Get Document Directory
    class func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        var documentsDirectory = paths[0]
        documentsDirectory.append("/MyDirectory")
        
        if !FileManager.default.fileExists(atPath: documentsDirectory){
            try! FileManager.default.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return documentsDirectory
    }
    
    func getFileNameIfExistAtDocumentDirectory(strMedia: String) -> String?{
        let docDir = AWSS3Manager.getDocumentsDirectory()
        let strLastComponent = URL(string: strMedia)?.lastPathComponent
        let fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(strLastComponent ?? "")
        // check file exist or not
        if FileManager.default.fileExists(atPath: fileURL.path){
            return strLastComponent
        }else{
            return nil
        }
    }
    
    func getFileURLFromName(strMedia: String) -> URL?{
        let docDir = AWSS3Manager.getDocumentsDirectory()
        let strLastComponent = URL(string: strMedia)?.lastPathComponent
        let fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(strLastComponent ?? "")
        // check file exist or not
        if FileManager.default.fileExists(atPath: fileURL.path){
            return fileURL
        }else if strMedia.isValidForUrl(){
            return URL(string: strMedia)
        }else{
            return nil
        }
    }
    
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }
    
    func checkDeviceFreeSpaceAvailable() -> Bool{
        if let bytes = self.deviceRemainingFreeSpaceInBytes() {
            print("free space : \(bytes/1048576) MB")
            if (bytes/(1024*1024)) < 250{
                Utilities.showCustomToast(message: "Insufficient storage.")
                return false
            }
        }
        return true
    }
    
    func createNewMediaFromDocumentDirecotoryPath(imageDocDirName: String, mediaContentType: MediaContentType, completion:@escaping (_ remoteName: String?,_ thumbnailRemoteName: String?) -> Void){
        let docDir = AWSS3Manager.getDocumentsDirectory()
        let timeInSeconds = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "_")
        
        var remoteName = ""
        var fileNewURL:URL?
        var thumbnailRemoteName = ""
        var fileNewThumbURL:URL?
        
        switch mediaContentType {
        // for JPEG or PNG Image Type
        case .ImageJPEG,.ImagePNG:
            remoteName = "\(timeInSeconds)_image.jpg"
            fileNewURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            thumbnailRemoteName = "thumb_\(remoteName)"
            //            thumnailRemoteName = thumnailRemoteName.replacingOccurrences(of: ((thumnailRemoteName ?? "") as NSString).pathExtension, with: "jpg")
            fileNewThumbURL = URL(fileURLWithPath: docDir).appendingPathComponent(thumbnailRemoteName)
            
            break
        case .VideoMOV,.VideoMP4:
            remoteName = "\(timeInSeconds)_video.mov"
            fileNewURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            thumbnailRemoteName = "thumb_\(remoteName)"
            thumbnailRemoteName = thumbnailRemoteName.replacingOccurrences(of: (thumbnailRemoteName as NSString).pathExtension, with: "jpg")
            fileNewThumbURL = URL(fileURLWithPath: docDir).appendingPathComponent(thumbnailRemoteName)
            
            break
        default:
            break
        }
        
        if let fileNewURL = fileNewURL, let fileNewThumbURL = fileNewThumbURL{
            //If Document Directory path passed then copy item from source to new path
            
            let thumbDocDirName = "thumb_\(imageDocDirName)".replacingOccurrences(of: (imageDocDirName as NSString).pathExtension, with: "jpg")
            if let sourceURL = self.getFileURLFromName(strMedia: imageDocDirName), let thumbSourceURL = self.getFileURLFromName(strMedia: thumbDocDirName){
                if FileManager.default.fileExists(atPath: sourceURL.path){
                    do {
                        try FileManager.default.copyItem(at: sourceURL, to: fileNewURL)
                        
                        try FileManager.default.copyItem(at: thumbSourceURL, to: fileNewThumbURL)
                        
                        // check file exist or not
                        if FileManager.default.fileExists(atPath: fileNewURL.path) && FileManager.default.fileExists(atPath: fileNewThumbURL.path){
                            completion(remoteName, thumbnailRemoteName)
                        }else{
                            completion(nil,nil)
                        }
                    }
                    catch {
                        completion(nil,nil)
                    }
                }else{
                    completion(nil,nil)
                }
            }else{
                completion(nil,nil)
            }
        }else{
            completion(nil,nil)
        }
    }
    
    // Save Image In Document Directory
    func saveImageInDocumentDirectoryPath(image: UIImage, imageDocDirPath: String, mediaContentType: MediaContentType, mediaURL: String, isCompress: Bool, completion:@escaping (String?) -> Void) {
    
        let docDir = AWSS3Manager.getDocumentsDirectory()
        let timeInSeconds = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "_") // set uniqe file name add
        
        switch mediaContentType {
        // for JPEG or PNG Image Type
        case .ImageJPEG,.ImagePNG:
            let remoteName = "\(timeInSeconds)_image.jpg"
            let fileNewURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            if imageDocDirPath == "" {
                //image will be replaced on the older path so remove it. Or new image will be stored in document directory.
                if let fileURL = mediaURL != "" ? AWSS3Manager.sharedInstance.getFileURLFromName(strMedia: mediaURL) : fileNewURL {
                    //write data in document directory
                    self.removeFile(fileURL)
                    DispatchQueue.main.async {
                        do {
                            let orientationImage = self.imageOrientation(image)
                            var data = (orientationImage).jpegData(compressionQuality: isCompress ?JPEGQuality.medium.rawValue : JPEGQuality.high.rawValue)
                            let imageSize = (data?.count ?? 0 ) / 1024 // kb Size
                            print("Upload Image Size : %d kb",imageSize)
                            
                            try data?.write(to: fileNewURL)
                            
                            data = nil
                            
                            // check file exist or not
                            if FileManager.default.fileExists(atPath: fileNewURL.path){
                                completion(remoteName)
                            }else{
                                completion(nil)
                            }
                        }catch {
                            print("Fail")
                            completion(nil)
                        }
                    }
                }else{
                    completion(nil)
                }
            }else{
                //If Document Directory path passed then copy item from source to new path
                if let sourceURL = self.getFileURLFromName(strMedia: imageDocDirPath){
                    if FileManager.default.fileExists(atPath: sourceURL.path){
                        do {
                            try FileManager.default.copyItem(at: sourceURL, to: fileNewURL)
			    
                            // check file exist or not
                            if FileManager.default.fileExists(atPath: fileNewURL.path){
                                completion(remoteName)
                            }else{
                                completion(nil)
                            }
                        }
                        catch {
                            completion(nil)
                        }
                    }else{
                        completion(nil)
                    }
                }else{
                    completion(nil)
                }
            }
            break
        default:
            break
        }
    }
    
    // Save Thumbnail Image In Document Directory
    func saveThumbnailImageInDocumentDirectory(image: UIImage, imageDocDirPath: String?, mediaContentType: MediaContentType, remoteName: String , isCompress: Bool, completion:@escaping (String?) -> Void) {
        let docDir = AWSS3Manager.getDocumentsDirectory()
        
        // find medea content type
        switch mediaContentType {
        // for JPEG or PNG Image Type
        case .ImageJPEG,.ImagePNG:
            let remoteName = remoteName
            let fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            //write data in document directory
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let orientationImage = self.imageOrientation(image)
                    UIImageWriteToSavedPhotosAlbum(orientationImage, nil, nil, nil)
                    if let thumbnailSizeImage = self.ResizeImage(image: orientationImage, targetSize: CGSize(width: 300, height: 300)) {
                        var data = (thumbnailSizeImage).jpegData(compressionQuality: isCompress ?JPEGQuality.medium.rawValue : JPEGQuality.high.rawValue)
                        let imageSize = (data?.count ?? 0 ) / 1024 // kb Size
                        print("Upload Image Size : %d kb",imageSize)
                        try data?.write(to: fileURL)
                        
                        data = nil
                        
                        //check file exist or not
                        if FileManager.default.fileExists(atPath: fileURL.path){
                            completion(remoteName)
                        }else{
                            completion(nil)
                        }
                    }
                }
                catch {
                    print("Fail")
                    completion(nil)
                }
            }
            break
        default:
            break
        }
    }
    
    // Save Video In Document Directory with compression
    func saveVideoInDocumentDirectory(url: String, isReportMediaAsset: Bool = false, mediaContentType: MediaContentType, completion:@escaping (String?) -> Void) {
        let docDir = AWSS3Manager.getDocumentsDirectory()
        let timeInSeconds = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "_") // set uniqe file name add
        var remoteName = ""
        var outputVideoURL : URL?
        var fileURL : URL?
        // find medea content type
        switch mediaContentType {
            
        case .VideoMOV:
            remoteName = "\(timeInSeconds)_video.mov"
            fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(String((Date().timeIntervalSince1970)) + "_video.mov")
            outputVideoURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            break
        case .VideoMP4:
            remoteName = "\(timeInSeconds)_video.mp4"
            fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(String(Int(Date().timeIntervalSince1970)) + "_video.mp4")
            outputVideoURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
            
            break
        default:
            break
        }
        
        LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 7: Store video from url \(url) \n fileURL: \(fileURL?.absoluteString ?? "Not found") \n Output URL \(outputVideoURL?.absoluteString ?? "Not found")")
        
        // store video in document directory
        let videoURL = URL(string: url)
        if let videoUrl = videoURL{
            //let data = try? Data(contentsOf: videoUrl)
            // write data in document directory
            if let fileURL = fileURL{
                do {
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 9: copy at \(videoUrl.absoluteString) to \(fileURL.absoluteString)")
                    try FileManager.default.copyItem(at: videoUrl, to: fileURL)
                    //try data?.write(to: fileURL)
                    print("Store file.")
                }
                catch {
                    print("Fail")
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 9: Failed to copy \(error.localizedDescription)")
                    print(error.localizedDescription)
//                    completion(nil)
                }
            }
        }else{
            LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 8: URL nil")
        }
        
        if let outputVideoURL = outputVideoURL{
            if let fileURL = fileURL {
                // check file exist or not
                if FileManager.default.fileExists(atPath: fileURL.path){
                    // Compress Video
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 1")
                    MediaCompress.sharedInstance.compressVideo(inputVideoURL: fileURL , outputVideoURL: outputVideoURL, completion: { (compressURL) in
                        LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 1 completion url \(compressURL) , remoteName \(remoteName)")
                        completion(compressURL.lastPathComponent)
                    })
                }else if let videoURL = videoURL, videoURL.scheme == "assets-library"{
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 2")
                    if isReportMediaAsset{
                        self.storeAssetAtUrl(assetUrl: videoURL, outputUrl: outputVideoURL, success: { (success) in
                            LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 2 success \(success), remotename \(remoteName)")
                            if success{
                                completion(remoteName)
                            }else{
                                completion(nil)
                            }
                        })
                    }else{
                        // Compress Video
                        LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 3")
                        MediaCompress.sharedInstance.compressVideo(inputVideoURL: videoURL , outputVideoURL: outputVideoURL, completion: { (compressURL) in
                            LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: Compress 3 completion url \(compressURL) , remoteName \(remoteName)")
                            completion(compressURL.lastPathComponent)
                        })
                    }
                }else{
                    print("File does not exists.")
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: "Step 10: No compression file not exist")
                    completion(nil)
                }
            }
        }
    }
    
    // store and upload Image Type media content
    func storeMediaAndGetFileURLForImage(image: UIImage, mediaContentType: MediaContentType,bucketname: AWSBucket,withSuccess success: @escaping (_ success:String,_ thumbName:String) -> Void, failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void){
        if(Utilities.checkInternetConnection())
        {
            let docDir = AWSS3Manager.getDocumentsDirectory()
            let timeInSeconds = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "_") // set uniqe file name add
            
            // find medea content type
            switch mediaContentType {
            // for JPEG or PNG Image Type
            case .ImageJPEG,.ImagePNG:
                let remoteName = "\(timeInSeconds)_image.jpg"
                let fileURL = URL(fileURLWithPath: docDir).appendingPathComponent(remoteName)
                let orientationImage = imageOrientation(image)
                // write data in document directory
                do {
                    let data = (orientationImage).jpegData(compressionQuality: JPEGQuality.medium.rawValue)
                    let imageSize = (data?.count ?? 0 ) / 1024 // kb Size
                    print("Upload Image Size : %d kb",imageSize)
                    try data?.write(to: fileURL)
                }
                catch {
                    print("Fail")
                }
                // check file exist or not
                if FileManager.default.fileExists(atPath: fileURL.path){
                    self.uploadMedia(fileURL: fileURL, fileName: remoteName, mediaContentType: .ImageJPEG, bucketname: bucketname, withSuccess: {
                        (fileURL) in
                        success(fileURL, remoteName)
                    }, failure: {(error) in
                        failure(error)
                    }, connectionFail: {(error) in
                        connectionFail(error)
                    })
                }else{
                    print("File does not exists.")
                }
                break
            default:
                break
            }
        }else
        {
            connectionFail(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
   
   
    // Upload media content to AWS S3 Bucket
    func uploadMedia(fileURL: URL, fileName: String, mediaContentType: MediaContentType,bucketname: AWSBucket,withSuccess success: @escaping (_ success:String) -> Void, failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void)
    {
        if(Utilities.checkInternetConnection())
        {
            // setup AWS S3 Bucket transfer manager upload request data
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = fileURL
            uploadRequest?.key = fileName
            uploadRequest?.bucket = bucketname.rawValue
            uploadRequest?.contentType = mediaContentType.rawValue
            uploadRequest?.acl = .publicRead
            
            // create AWS S3 Bucket transfer manager default
            let transferManager = AWSS3TransferManager.default()
            
            // send upload request to AWS S3 Bucket server
            transferManager.upload(uploadRequest!).continueWith {(task) -> Any? in
                var uploadRequestOfAWSS3 = "====== AWSS3 BUCKET UPLOAD MEDIA REQUEST ======\n"
                 uploadRequestOfAWSS3 = uploadRequestOfAWSS3 + "Storage Path : \(uploadRequest?.body.absoluteString ?? "")\n"
                uploadRequestOfAWSS3 = uploadRequestOfAWSS3 + "File Name : \(uploadRequest?.key ?? "")\n"
                uploadRequestOfAWSS3 = uploadRequestOfAWSS3 + "Bucket Name : \(uploadRequest?.bucket ?? "")\n"
                uploadRequestOfAWSS3 = uploadRequestOfAWSS3 + "Media Content Type : \(uploadRequest?.contentType ?? "")\n"
                uploadRequestOfAWSS3 = uploadRequestOfAWSS3 + "Access Permission : \(uploadRequest?.acl.rawValue ?? 0)\n"
                LogFileManager.sharedInstance.writeDataInLogFile(logData: uploadRequestOfAWSS3)
                
                // error
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                    let errorMsg = "Upload failed with error: (\(error.localizedDescription))"
                    //return errorMsg
                    LogFileManager.sharedInstance.writeDataInLogFile(logData: errorMsg)
                    failure(errorMsg)
                }
                // success result
                if task.result != nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent((uploadRequest?.bucket)!).appendingPathComponent((uploadRequest?.key)!)
                    // return Upload media file URL string
                    if let absoluteString = publicURL?.absoluteString {
                        print("Uploaded to:\(absoluteString)")
                        //self.removeFile(fileURL)
                        LogFileManager.sharedInstance.writeDataInLogFile(logData: absoluteString)
                        success(absoluteString)
                    }
                }
                return nil
            }
        }else
        {
//            SVProgressHUD.dismiss()
            connectionFail(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    func multipartUpload(fileUrl: URL, fileName: String, bucketName: AWSBucket, mediaContentType: MediaContentType, withSuccess success: @escaping (_ success:String) -> Void, failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void) {
        if(Utilities.checkInternetConnection())
        {
            var uploadString = ""
            //print("Url: \(fileUrl.absoluteString)")
            let expression = AWSS3TransferUtilityMultiPartUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Update a progress bar.
                    print("progress: \(progress.fractionCompleted)")
                })
            }
            expression.setValue("public-read", forRequestHeader: "x-amz-acl")
            
            var completionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?
            completionHandler = { (task, error) in
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Alert a user for transfer completion.
                    // On failed uploads, `error` contains the error object.
                    if let err = error {
                        print("Upload failed with error: (\(err.localizedDescription))")
                        failure(err.localizedDescription)
                    } else {
                        print("Upload success")
                        success(uploadString)
                    }
                })
            }
            
            let transferUtility = AWSS3TransferUtility.default()
            
            transferUtility.uploadUsingMultiPart(fileURL: fileUrl, bucket: bucketName.rawValue, key: fileName, contentType: mediaContentType.rawValue, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                    failure(error.localizedDescription)
                }
                
                if let result = task.result {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(result.bucket).appendingPathComponent(result.key)
                    if let absoluteString = publicURL?.absoluteString {
                        print("Uploaded to:\(absoluteString)")
                        uploadString = absoluteString
                    }
                }
                
                return nil
            }
        }else{
//            SVProgressHUD.dismiss()
            connectionFail(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // MARK:- Remove file data
    func removeFile(_ fileURL: URL) {
        let fileManager = FileManager.default
        let filePath = fileURL.path
      
        // check file exist or not
        if FileManager.default.fileExists(atPath: filePath){
            do {
                try fileManager.removeItem(atPath: filePath)
                print("File Remove Successfully.")
            }
            catch{
                print("File not remove.",error.localizedDescription)
            }
        }else{
            print("File does not exists.")
        }
    }
    
    func deleteDataFromDocumentDirectory(){
        let documentDirectoryPath = AWSS3Manager.getDocumentsDirectory()
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: documentDirectoryPath)
            
                for path in directoryContents{
                    let fullPath = documentDirectoryPath + "/" + path
                    try FileManager.default.removeItem(atPath: fullPath)
                }
        }catch{
            print("Data not deleted from document directory.")
        }
    }
    
    //Thumbnail for video file
    func thumbnailForVideofile(str: String) -> UIImage? {
        do {
            let url = URL(string: str)!
            let asset = AVURLAsset(url: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    // get orientatiuon image to upload
    func imageOrientation(_ src:UIImage) -> UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func storeStreamingVideo(videoURL: URL){
        DispatchQueue.global(qos: .background).async {
            if let urlData = NSData(contentsOf: videoURL)
            {
                let documentsPath = AWSS3Manager.getDocumentsDirectory()
                let filePath="\(documentsPath)/\(videoURL.lastPathComponent)"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    print("Video is saved in document directory !")
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
//                    }) { completed, error in
//                        if completed {
//                            print("Video is saved!")
//                        }
//                    }
                }
            }
        }
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height:  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func storeAssetAtUrl(assetUrl: URL, outputUrl: URL, success:@escaping (Bool) -> Void){
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        if let phAsset = fetchResult.firstObject {
            PHImageManager.default().requestAVAsset(forVideo: phAsset, options: PHVideoRequestOptions()) { (asset, audioMix, info) in
                if let asset = asset as? AVURLAsset {
                    do {
                        let videoData = try Data(contentsOf: asset.url)
                    
                        try videoData.write(to: outputUrl)
                        
                        // check file exist or not
                        if FileManager.default.fileExists(atPath: outputUrl.path){
                            success(true)
                        }else{
                            success(false)
                        }
                    }catch {
                        success(false)
                    }
                }
            }
        }else{
            success(false)
        }
    }
}
