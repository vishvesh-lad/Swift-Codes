//
//  UserModel.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

let kRes = "res"
let kData = "data"
let kMsg = "msg"
let kSuccess = "0"

let kDeviceType = "device_type"
let kDeviceToken = "device_token"
let kAppVersion = "app_version"
let kIpAddress = "ip_address"
let kToken = "token"

let kUserId = "user_id"
let KFirstName = "first_name"
let KMenuPermissionProfileId = "menu_permission_profile_id"
let kLastName = "last_name"
let kUserName = "username"
let kPassword = "password"
let kEmailAddress = "email_address"
let kCompanyId = "company_id"
let kMobilePhone = "mobile_phone"
let kOfficePhone = "office_phone"
let kSocialId = "social_id"
let kLoginType = "login_type"
let kUserConfiguration = "user_configuration"

class UserModel: NSObject, NSCoding {
    
    //Variable
    var user_id : Int?
    var first_name : String?
    var menu_permission_profile_id : Int?
    var last_name : String?
    var username : String?
    var password : String?
    var email_address : String?
    var company_id : Int?
    var mobile_phone : String?
    var office_phone : String?
    var social_id : Int?
    var login_type : String?
    
    var defaultShapeColor : String?
    var defaultFontType : String?

    //Initialization
    override init() {
        super.init()
    }
    
    //NSCoder init
    required init(coder decoder: NSCoder) {
        user_id = decoder.decodeObject(forKey: kUserId) as? Int
        first_name = decoder.decodeObject(forKey: KFirstName) as? String
        menu_permission_profile_id = decoder.decodeObject(forKey: KMenuPermissionProfileId) as? Int
        last_name = decoder.decodeObject(forKey: kLastName) as? String
        username = decoder.decodeObject(forKey: kUserName) as? String
        password = decoder.decodeObject(forKey: kPassword) as? String
        email_address = decoder.decodeObject(forKey: kEmailAddress) as? String
        company_id = decoder.decodeObject(forKey: kCompanyId) as? Int
        mobile_phone = decoder.decodeObject(forKey: kMobilePhone) as? String
        office_phone = decoder.decodeObject(forKey: kOfficePhone) as? String
        social_id = decoder.decodeObject(forKey: kSocialId) as? Int
        login_type = decoder.decodeObject(forKey: kLoginType) as? String
        defaultShapeColor = decoder.decodeObject(forKey: kIeShapeColor) as? String
        defaultFontType = decoder.decodeObject(forKey: kIeFontType) as? String
    }
    
    //NSCoder encode
    func encode(with coder: NSCoder) {
        coder.encode(user_id, forKey: kUserId)
        coder.encode(first_name, forKey: KFirstName)
        coder.encode(menu_permission_profile_id, forKey: KMenuPermissionProfileId)
        coder.encode(last_name, forKey: kLastName)
        coder.encode(username, forKey: kUserName)
        coder.encode(password, forKey: kPassword)
        coder.encode(email_address, forKey: kEmailAddress)
        coder.encode(company_id, forKey: kCompanyId)
        coder.encode(mobile_phone, forKey: kMobilePhone)
        coder.encode(office_phone, forKey: kOfficePhone)
        coder.encode(social_id, forKey: kSocialId)
        coder.encode(login_type, forKey: kLoginType)
        coder.encode(defaultShapeColor, forKey: kIeShapeColor)
        coder.encode(defaultFontType, forKey: kIeFontType)
    }
    
    //MARK:- Create model
    func modelWithDictionary(data:[String:Any]) -> UserModel {
        self.user_id = data[kUserId] as? Int
        self.first_name = data[KFirstName] as? String
        self.menu_permission_profile_id = data[KMenuPermissionProfileId] as? Int
        self.last_name = data[kLastName] as? String
        self.username = data[kUserName] as? String
        self.password = data[kPassword] as? String
        self.email_address = data[kEmailAddress] as? String
        self.company_id = data[kCompanyId] as? Int
        self.mobile_phone = data[kMobilePhone] as? String
        self.office_phone = data[kOfficePhone] as? String
        self.social_id = data[kSocialId] as? Int
        self.login_type = data[kLoginType] as? String
        
        if let userConfiguration = data[kUserConfiguration] as? [String:Any] {
            self.defaultShapeColor = userConfiguration[kIeShapeColor] as? String
            self.defaultFontType = userConfiguration[kIeFontType] as? String
        }
        return self
    }
}

