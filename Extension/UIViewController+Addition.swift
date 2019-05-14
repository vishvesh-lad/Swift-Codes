//
//  UIViewController+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import AVFoundation
import AVKit

extension UIViewController{
    
    //Play video from URL
    func playVideoFromUrl(videoURL:URL)
    {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: xvideoURL)
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //MARK Confirmation Alert With Handler
    func showAlert(title:String, description:String, okButtonTitle:String, cancelButtonTitle:String, acceptHandler: @escaping(_ isAccepted: Bool) ->()) {
        
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let accept = UIAlertAction (title: okButtonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil);
            acceptHandler(true)
        }
        
        if (cancelButtonTitle as NSString).length > 0
        {
            let cancel = UIAlertAction (title: cancelButtonTitle, style: .destructive) { (action) in
                alert.dismiss(animated: true, completion:nil);
                acceptHandler(false)
            }
            alert.addAction(cancel)
        }
        
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAttributedMessageAlert(title:String, description:NSAttributedString, okButtonTitle:String, cancelButtonTitle:String, acceptHandler: @escaping(_ isAccepted: Bool) ->()) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.setValue(description, forKey: "attributedMessage")
        
        let accept = UIAlertAction (title: okButtonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil);
            acceptHandler(true)
        }
        
        if (cancelButtonTitle as NSString).length > 0
        {
            let cancel = UIAlertAction (title: cancelButtonTitle, style: .destructive) { (action) in
                alert.dismiss(animated: true, completion:nil);
                acceptHandler(false)
            }
            alert.addAction(cancel)
        }
        
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }

}
