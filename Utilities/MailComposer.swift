//
//  MailComposer.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import MessageUI

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a mail can be sent from the user's device
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    // Configures and returns a MFMailComposeViewController instance
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self //Make sure to set this property to self, so that the controller can be dismissed!
        return mailComposeVC
    }
    
    //MARK:- MFMailComposeViewController Delegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
