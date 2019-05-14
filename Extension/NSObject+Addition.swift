//
//  NSObject+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension NSObject {
    //get Classname of object
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
