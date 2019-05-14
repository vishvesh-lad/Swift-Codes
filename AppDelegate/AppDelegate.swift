//
//  AppDelegate.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    //Variables
    var window: UIWindow?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    var isNotificationTokenChanged = false
    var isNotificationClicked = false

    //Reference to the application's delegate
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //APP finish lauch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //init singleton class
        _ = AppSingleton.sharedInstance
        
        //Configure Progress Loader
        setSVProgressHUDconfiguration()
        
        //Configure KeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        IQKeyboardManager.sharedManager().disabledToolbarClasses = [ImageViewerCaptionVC.self]
        
        //Set UINavigationBar appearance
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): (UIColor.white)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().barTintColor = UIColor.CustomColor.navigationBarColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.CustomColor.navigationBarColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //Set UIApplication properties
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Set UIApplication idleTimerDisable
        UIApplication.shared.isIdleTimerDisabled = true
        
        //Set UITextField/UITextView tintColor
        UITextField.appearance().tintColor = .white
        UITextView.appearance().tintColor = .white
        
        //Set SeachBar TextColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): (UIColor.white)
        ]
        
        //Set LaunchOptions
        self.launchOptions = launchOptions
        
        //Custom LaunchScreen
        let mainStoryboard = UIStoryboard.init(name: StoryBoardIdentifier.MainStoryBoard, bundle: nil)
        let objLaunchScreenVC = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.LaunchScreenVC)
        self.window?.rootViewController = objLaunchScreenVC
        self.window?.backgroundColor = UIColor.clear
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //Check user is already LoggedIn or not and set content view controller
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:. managed object context before the application terminates.
    }

    // MARK: - Private Methods
    //SVProgressHUD configuration Method
    func setSVProgressHUDconfiguration() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.2))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.5))
        if DeviceConstant.isDeviceTypeIpad() 
        {
            SVProgressHUD.setMinimumSize(CGSize(width: 150, height: 150))
        }else
        {
            SVProgressHUD.setMinimumSize(CGSize(width: 75, height: 75))
        }
    }
    
    //Setup Dashboard
    func onSetupDashboardPage() {
        //REFrostedViewController: Set Menu view and content view
        let objREFrostedViewController = REFrostedViewController()
        
        //Set Menu view controller
        let mainStoryboard = UIStoryboard.init(name: StoryBoardIdentifier.MainStoryBoard, bundle: nil)
        var DashboardStoryboard: UIStoryboard?
        var rearViewController: UIViewController?
        let roleId = AppSingleton.sharedInstance.activeUser?.role?.role_id ?? 0
        DashboardStoryboard = UIStoryboard.init(name: StoryBoardIdentifier.DashBoardStoryBoard, bundle: nil)
        rearViewController = DashboardStoryboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.MenuVC)
        rearViewController?.view.backgroundColor = UIColor.CustomColor.appThemeBackgroundColor
        objREFrostedViewController.menuViewController = rearViewController
        objREFrostedViewController.menuViewSize.width = ScreenSize.SCREEN_WIDTH * 0.8
        objREFrostedViewController.limitMenuViewSize = true
        
        let frontViewController = UINavigationController.init(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.LoginVC))
        frontViewController.view.backgroundColor = UIColor.CustomColor.appThemeBackgroundColor
        objREFrostedViewController.contentViewController = frontViewController
        
        //Set Statusbar background color
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.CustomColor.statusbarColor
        
        //Set App window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = objREFrostedViewController
        self.window?.backgroundColor = UIColor.clear
        self.window?.makeKeyAndVisible()
    }
    
    //Device info
    func getDeviceInfoStr() -> String{
        var deviceInfo = kDeviceName + " = " + UIDevice.current.name + "\n"
        deviceInfo.append(kModelName + " = " + UIDevice().type.rawValue + "\n")
        deviceInfo.append(kDeviceModel + " = " + UIDevice.current.model + "\n")
        deviceInfo.append(kSystemName + " = " + UIDevice.current.systemName + "\n")
        deviceInfo.append(kSystemVersion + " = " + UIDevice.current.systemVersion + "\n")
        deviceInfo.append(kAppName + " = " + UIApplication.appBundleDisplayName() + "\n")
        deviceInfo.append(kVersionName + " = " + UIApplication.appVersion() + "\n")
        deviceInfo.append(kBuildNumber + " = " + UIApplication.appBuild())
        return deviceInfo
    }
    
    //Device info
    func getDeviceInfoDict() -> [String: Any]{
        let deviceDict:[String : Any] = [kDeviceName:UIDevice.current.name, kModelName: UIDevice().type.rawValue, kDeviceModel: UIDevice.current.model, kSystemName: UIDevice.current.systemName, kSystemVersion: UIDevice.current.systemVersion, kAppName: UIApplication.appBundleDisplayName(), kVersionName: UIApplication.appVersion(), kBuildNumber: UIApplication.appBuild()]
        return deviceDict
    }
    
    //Redirect to screen
    func logoutUser(){
        //Logout
        UserDefaultUtility.sharedInstance.clearData()
        
        let nav = (UIApplication.topViewController() as? REFrostedViewController)?.contentViewController as? UINavigationController
        let storyboard = UIStoryboard.init(name: StoryBoardIdentifier.MainStoryBoard, bundle: nil)
        let objViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.LoginVC)
        nav?.viewControllers = [objViewController]
    }
}
