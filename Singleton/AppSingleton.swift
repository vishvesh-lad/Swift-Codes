//
//  AppSingleton.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

class AppSingleton: NSObject {
    
    //Singleton class
    static let sharedInstance = AppSingleton()
    
    //Store LoggedIn user detail
    var objUserLoginModel: UserLoginModel {
        get {
            guard let objUserLoginModel = UserDefaultUtility.sharedInstance.retrieveFromDefault(key: AppConstant.DataModelKey.kActiveUser) as? UserLoginModel else {
                return nil
            }
            return objUserLoginModel
        }
        set(objUserLoginModel) {
            UserDefaultUtility.sharedInstance.storeInDefault(object: objUserLoginModel, key: AppConstant.DataModelKey.kActiveUser)
        }
    }
    
    override init() {
        super.init()
    }
}
