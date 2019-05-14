//
//  UserLoginModel.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

let kUser = "user"
let KRole = "role"
let kDeviceUniqueId = "device_unique_id"
let kDeviceName = "device_name"
let kModelName = "model_name"
let kDeviceModel = "device_model"
let kSystemVersion = "system_version"
let kSystemName = "system_name"
let kDeviceInfo = "device_info"
let kAppName = "app_name"
let kVersionName = "version_name"
let kBuildNumber = "build_number"
let kAccesssTokenKey = "accesss_token_key"
let kAccessToken = "access_token"
let kDeveloperCode = "developer_code"

class UserLoginModel: NSObject, NSCoding {
    //Variables
    var user : UserModel?
    var role: RoleModel?
    
    //Initialization
    override init() {
        super.init()
    }
    
    //NSCoder init
    required init(coder decoder: NSCoder) {
        user = decoder.decodeObject(forKey: kUser) as? UserModel
        company = decoder.decodeObject(forKey: KCompany) as? CompanyModel
        employee = decoder.decodeObject(forKey: KEmployee) as? EmployeeModel
        role = decoder.decodeObject(forKey: KRole) as? RoleModel
        contact = decoder.decodeObject(forKey: kContact) as? ContactModel
    }
    
    //NSCoder encode
    func encode(with coder: NSCoder) {
        coder.encode(user, forKey: kUser)
        coder.encode(company, forKey: KCompany)
        coder.encode(employee, forKey: KEmployee)
        coder.encode(role, forKey: KRole)
        coder.encode(contact,forKey: kContact)
    }
    
    //MARK:- Create model
    func modelWithDictionary(data:[String:Any]) -> UserLoginModel {
        if let userData = data[kUser] as? [String:Any] {
            user = UserModel().modelWithDictionary(data: userData)
        }
        
        if let roleData = data[KRole] as? [String:Any] {
            role = RoleModel().modelWithDictionary(data: roleData)
        }
        
        return self
    }
    
    //MARK:- API Call
    //Call API for Login
    class func LoginUser(emailId: String?, password: String?, success withResponse: @escaping (UserLoginModel) -> (), failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void){
        SVProgressHUD.show()
        var dictParam = [String : Any]()
        dictParam[kUserName] = emailId
        dictParam[kPassword] = password
        
        APIManager.sharedInstance.callURLStringJson(AppConstant.serverAPI.URL.kLogin, httpMethod: .post, isPassHeader: false, withRequest: dictParam, withSuccess: { (response) in
            if let res = response as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    if let userData = res[kData] as? [String:Any] {
                        //Check if AuthToken included then Store in UserDafault
                        if let authToken = res[kToken] as? String {
                            //Set token
                            UserDefaultUtility.sharedInstance.storeInDefault(object: authToken, key: AppConstant.DataModelKey.kAuthorization)
                        }
                        
                        //Bind login response and store user, employee and company detail
                        let objUserLoginDetail = UserLoginModel().modelWithDictionary(data: userData)
                        AppSingleton.sharedInstance.activeUser = objUserLoginDetail
                        UserDefaultUtility.sharedInstance.storeInDefault(object: objUserLoginDetail, key: AppConstant.DataModelKey.kActiveUser)
                        withResponse(objUserLoginDetail)
                    }
                } else {
                    let msg = res[kMsg] as? String
                    Utilities.showCustomToast(message: msg)
                    failure(msg ?? "")
                }
            }
            SVProgressHUD.dismiss()
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            Utilities.showCustomToast(message: error)
            failure(error)
        }, connectionFailed: { (connectionFailed) in
            SVProgressHUD.dismiss()
            Utilities.showCustomToast(message: connectionFailed)
            connectionFail(connectionFailed)
        })
    }
    
    //Call API for Forgot Password
    class func ForgotPassword(emailId: String?, success withResponse: @escaping () -> (), failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void){
        
        SVProgressHUD.show()
        var dictParam = [String : Any]()
        dictParam[kEmailAddress] = emailId
        
        APIManager.sharedInstance.callURLStringJson(AppConstant.serverAPI.URL.kForgotPassword, httpMethod: .post, withRequest: dictParam, withSuccess: { (response) in
            if let res = response as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    let msg = res[kMsg] as? String
                    Utilities.showCustomToast(message: msg)
                    withResponse()
                } else {
                    let msg = res[kMsg] as? String
                    Utilities.showCustomToast(message: msg)
                    failure(msg ?? "")
                }
            }
            SVProgressHUD.dismiss()
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            Utilities.showCustomToast(message: error)
            failure(error)
        }, connectionFailed: { (connectionFailed) in
            SVProgressHUD.dismiss()
            Utilities.showCustomToast(message: connectionFailed)
            connectionFail(connectionFailed)
        })
    }
}
