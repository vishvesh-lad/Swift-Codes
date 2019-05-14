//
//  DZNWebViewController.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

class DZNCustomWebViewController: NSObject {
    
    // MARK:- Variables
    static let sharedInstance = DZNCustomWebViewController()
    
    var objDZNWebViewController:DZNWebViewController?
    
    // MARK:- Initialization
    override init() {
        super.init()
    }
    
    //Show WebView from URL
    func openURLInWebView(strLink: String){
        
        var strURL = strLink
        if !strURL.starts(with: "http://") && !strURL.starts(with: "https://"){
            strURL = "http://\(strURL)"
        }
        
        objDZNWebViewController = DZNWebViewController(url: URL(string: strURL))
        let navigationController = UINavigationController(rootViewController: objDZNWebViewController!)
        objDZNWebViewController?.supportedWebNavigationTools = .all
        objDZNWebViewController?.supportedWebActions = .DZNWebActionAll
        //objDZNWebViewController?.webNavigationPrompt = DZNWebNavigationPromptAll;
        objDZNWebViewController?.showLoadingProgress = true
        objDZNWebViewController?.allowHistory = true
        objDZNWebViewController?.hideBarsWithGestures = false
        
        let btnLeft:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "CloseIcon"), style: .plain, target: self, action: #selector(self.dismissViewController))
        objDZNWebViewController?.navigationItem.leftBarButtonItem = btnLeft
        //objDZNWebViewController?.navigationItem.title = linkURL.absoluteString
        
        let VC = UIApplication.topViewController()
        VC?.present(navigationController, animated: true, completion: nil)
    }

    @objc func dismissViewController(){
        //Post a notification for AVPlayerViewController dismissal
        NotificationCenter.default.post(name: .kDismissViewControllerNotification, object: nil)
        objDZNWebViewController?.dismiss(animated: true, completion: nil)
    }
}
