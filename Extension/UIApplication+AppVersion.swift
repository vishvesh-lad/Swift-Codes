//
//  UIApplication+AppVersion.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension UIApplication {
    
    //App version
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    //Build
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    //Bundle name
    class func appBundleName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    //Bundle Display name
    class func appBundleDisplayName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    //Version and build
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    //Status Bar View
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    //Find top most view controller
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    //check application state
    class func isApplicationInForeground() -> Bool {
        let state: UIApplication.State = UIApplication.shared.applicationState
        let result: Bool = (state == .active)
        return result
    }
    
    class func isApplicationInBackground() -> Bool {
        let state: UIApplication.State = UIApplication.shared.applicationState
        let result: Bool = (state == .inactive)
        return result
    }
}
