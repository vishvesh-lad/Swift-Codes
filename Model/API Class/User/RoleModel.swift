//
//  RoleModel.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

let KRoleId = "role_id"
let KRoleName = "role_name"

class RoleModel: NSObject, NSCoding {
    //Variable
    var role_id : Int?
    var role_name : String?
    
    //Initialization
    override init() {
        super.init()
    }
    
    //NSCoder init
    required init(coder decoder: NSCoder) {
        role_id = decoder.decodeObject(forKey: KRoleId) as? Int
        role_name = decoder.decodeObject(forKey: KRoleName) as? String
    }
    
    //NSCoder encode
    func encode(with coder: NSCoder) {
        coder.encode(role_id, forKey: KRoleId)
        coder.encode(role_name, forKey: KRoleName)
    }
    
    //MARK:- Create model
    func modelWithDictionary(data:[String:Any]) -> RoleModel {
        role_id = data[KRoleId] as? Int
        role_name = data[KRoleName] as? String
        
        return self
    }
}
