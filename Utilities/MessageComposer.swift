//
//  MessageComposer.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- MFMessageComposeViewController Delegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            controller.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
}
