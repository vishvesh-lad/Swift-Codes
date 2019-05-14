//
//  Font+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

//Custom fonts with size
extension UIFont {
    class func customFontReguler(with size:CFloat)-> UIFont{
        return UIFont(name: "Roboto-Regular", size: CGFloat(size))!
    }
    
    class func customFontBold(with size:CFloat)-> UIFont{
        return UIFont(name: "Roboto-Bold", size: CGFloat(size))!
    }
    
    class func customFontMedium(with size:CFloat)-> UIFont{
        return UIFont(name: "Roboto-Medium", size: CGFloat(size))!
    }
    
    class func customFontLight(with size:CFloat)-> UIFont{
        return UIFont(name: "Roboto-Light", size: CGFloat(size))!
    }
}
