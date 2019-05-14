//
//  DeviceConstant.swift
//  Created by Vicky Prajapati.
//

import Foundation

class AppConstant: NSObject {
    static let deviceType = "Iphone"
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    // DataModel UserDefault keys
    struct DataModelKey {
        static let KDeviceToken                    = "device_token"
        static let KIsAppAlreadyLaunchedOnce       = "isAppAlreadyLaunchedOnce"
        static let kActiveUser                     = "ActiveUser"
        static let kAuthorization                  = "Authorization"
    }
    
    struct ConfigKeys {
        static let GoogleMapAPIKey = "//KEY//"
    }
    
    //MARK: API constants
    struct serverAPI {
        struct URL {
            static let kBaseURL                  = "https://test.com/API/"

            static let kV1                       = "v1/"
            static let AuthTokenPrefix           = "Bearer %@"
            static let BaseUrlVersion            = kBaseURL + kV1
            
            static let kLogin                    = BaseUrlVersion + "Login"
            
        }
        
        struct errorMessages {
            static let kNoInternetConnectionMessage     = "Please check your internet connection."
            static let kCommanErrorMessage              = "Something went wrong please try again later."
        }
    }
}
