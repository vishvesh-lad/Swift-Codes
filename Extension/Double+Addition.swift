//
//  Double+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension Double {
    func roundUpString() -> String{
        return String(format: "%.2f", Double(Darwin.round(100 * self) / 100))
    }
    
    func roundUpDouble() -> Double{
        return Double(Darwin.round(100 * self) / 100)
    }
    
    var formattedAsUSCurrency: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.roundingMode = .down
        currencyFormatter.locale = Locale(identifier: "en-US")
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
    
    func numberFormatting() -> (str:String,value:Double){
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.roundingMode = .down
        numberFormatter.numberStyle = .decimal
       
        let str = numberFormatter.string(from: NSNumber(value: self))
        let value = Double(str?.replacingOccurrences(of: ",", with: "") ?? "")
        return (str ?? "",value ?? 0)
    }
    
    // formatting text for currency textField
    func currencyInputFormatToString() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        number = NSNumber(value: self)
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
