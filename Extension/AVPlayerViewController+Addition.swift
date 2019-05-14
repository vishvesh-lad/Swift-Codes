//
//  AVPlayerViewController+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import AVFoundation
import AVKit

extension AVPlayerViewController{
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarView?.isHidden = true
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.isHidden = false
        
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }
        
        //Post a notification for AVPlayerViewController dismissal
        NotificationCenter.default.post(name: .kDismissViewControllerNotification, object: nil)
    }
}
