//
//  UserDefaultUtility.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

class UserDefaultUtility: NSObject {
    static let sharedInstance = UserDefaultUtility()
    
    //Check App first time launch
    func isAppAlreadyLaunchedOnce()->Bool{
        if let isAppAlreadyLaunchedOnce = UserDefaults.standard.string(forKey: AppConstant.DataModelKey.KIsAppAlreadyLaunchedOnce){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            print("App launched first time")
            return false
        }
    }
    
    //Set App Launched first time to true on GetStarted
    func appLaunchedFirstTime()
    {
        UserDefaults.standard.set(true, forKey: AppConstant.DataModelKey.KIsAppAlreadyLaunchedOnce)
    }
   
    //Store data to user default
    func storeInDefault(object:Any,key:String) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    //retrieve data from user default
    func retrieveFromDefault(key:String) ->  AnyObject?
    {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: key) {
            let object = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return object as AnyObject
        }else{
            return nil
        }
    }
    
    //remove data from user default
    func removeFromDefault(key: String)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    //Clear Data on logout
    func clearData()
    {
        //Remove all data related to user on Logout
        APIManager.sharedInstance.cancelAllRequests()
//        CoreDataService.sharedInstance.clearCoreDataStore()//resetData()
//        CoreDataService.sharedInstance.getContext(coreDataContextEnum: .OfflineUploadPrivateContext).reset()
    CoreDataService.sharedInstance.getContext(coreDataContextEnum: .PrivateContext).reset()
        CoreDataService.sharedInstance.getContext().reset()
        CoreDataService.sharedInstance.clearCoreDataStore()
        AWSS3Manager.sharedInstance.deleteDataFromDocumentDirectory()
        
        AppSingleton.sharedInstance.activeUser = nil
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: AppConstant.DataModelKey.kActiveUser)
        userDefaults.set(nil, forKey: AppConstant.DataModelKey.kAuthorization)
        userDefaults.synchronize()
        
        SocketIOManager.sharedInstance.closeConnection()
    }
}
