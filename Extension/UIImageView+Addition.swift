//
//  UIImageView+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageMedia(_ thumbnailImageName: Any?) {
        image = nil
        
        // image does not available in cache.. so retrieving it from url...
        //get file from document direcotry or not avilable then url and then load from cache if not in cache then from url
        if let imageName = thumbnailImageName as? String, let requestImageURL = AWSS3Manager.sharedInstance.getFileURLFromName(strMedia: imageName){
            
            //retrieves image if already available in cache
            if let imageFromCache = imageCache.object(forKey: requestImageURL as AnyObject) as? UIImage {
                self.image = imageFromCache
                return
            }
            
            self.sd_setImage(with: requestImageURL, placeholderImage: UIImage(named: "PlaceholderBanner"), completed: { (imageToCache, error, cacheType, imageURL) in
                
                if let imageAvailable = imageToCache {
                    if requestImageURL == imageURL {
                        self.image = imageAvailable
                    }
                    imageCache.setObject(imageAvailable, forKey: imageURL as AnyObject)
                }else{
                    self.image = UIImage(named: "PlaceholderBanner")
                }
            })
        }else if let image = thumbnailImageName as? UIImage {
            self.image = image
        }else{
            self.image = UIImage(named: "PlaceholderBanner")
        }
    }
}
