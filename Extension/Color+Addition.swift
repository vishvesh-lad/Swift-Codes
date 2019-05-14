//
//  Color+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

import UIKit

extension UIColor {
    //UIColor from hex code
    convenience init(rgbhex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((rgbhex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbhex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbhex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgbHex: UInt32 = 0
        guard scanner.scanHexInt32(&rgbHex) else {
            return nil
        }
        
        self.init(rgbhex: Int(rgbHex), alpha: alpha)
    }
    
    
    @nonobjc
    convenience init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
