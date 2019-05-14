//
//  String+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension String {
    
    //Contains string
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    //Replace First occurance only if string start with prefix
    func replaceFirstIfPrefixMatch(prefix: String, replaceString: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return self.replaceFirst(of: prefix, with: replaceString)
    }
    
    //Replace First matching occurance of string
    func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
    
    //Replace all matching occurance of string
    func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        }catch{
            NSLog("replaceAll error: \(error)")
            return self
        }
    }
    
    //Check is valid url or not
    func isValidForUrl() -> Bool{
        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
    
    //HTML rendering
    func customHtmlAttributedString(fontSize: CFloat) -> NSAttributedString{
        var boldFont = UIFont.customFontBold(with: fontSize)
        if DeviceConstant.isDeviceTypeIpad()
        {
            boldFont = UIFont.customFontBold(with: fontSize * 2)
        }
        var regulerFont = UIFont.customFontReguler(with: fontSize)
        if DeviceConstant.isDeviceTypeIpad()
        {
            regulerFont = UIFont.customFontReguler(with: fontSize * 2)
        }
        var italicFont = UIFont.customFontLight(with: fontSize)
        if DeviceConstant.isDeviceTypeIpad()
        {
            italicFont = UIFont.customFontLight(with: fontSize * 2)
        }
        
        let dictAttrib: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        let attrib = try? NSMutableAttributedString(data: (self.data(using: String.Encoding.utf8))!, options: dictAttrib, documentAttributes: nil)
        
        attrib?.beginEditing()
        attrib?.enumerateAttribute(NSAttributedString.Key.font, in: NSRange(location: 0, length: (attrib?.length)!), options: [], using: {(value , range , stop) in
            
            if value != nil {
                guard let customFont = value as? UIFont else {
                    return
                }
                attrib?.removeAttribute(NSAttributedString.Key.font, range: range)
                
                if customFont.fontName.lowercased().contains("bold"){
                    
                    attrib?.addAttribute(NSAttributedString.Key.font, value: boldFont, range: range)
                }else if customFont.fontName.lowercased().contains("italic"){
                    
                    attrib?.addAttribute(NSAttributedString.Key.font, value: italicFont, range: range)
                }else{
                    
                    attrib?.addAttribute(NSAttributedString.Key.font, value: regulerFont, range: range)
                }
            }
        })
        attrib?.endEditing()
        return attrib!
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    //String to Bool
    func boolValue() -> Bool? {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func MediaContentType() -> MediaContentType{
        let url = URL(string: self)
        let extention = url?.pathExtension
        
        if extention?.caseInsensitiveCompare("png") == ComparisonResult.orderedSame {
            return .ImagePNG
        }
        else if extention?.caseInsensitiveCompare("jpg") == ComparisonResult.orderedSame {
            return .ImageJPEG
        }
        else if extention?.caseInsensitiveCompare("jpeg") == ComparisonResult.orderedSame {
            return .ImageJPEG
        }
        else if extention?.caseInsensitiveCompare("m4a") == ComparisonResult.orderedSame {
            return .AudioM4A
        }
        else if extention?.caseInsensitiveCompare("mov") == ComparisonResult.orderedSame {
            return .VideoMOV
        }
        else if extention?.caseInsensitiveCompare("mp4") == ComparisonResult.orderedSame {
            return .VideoMP4
        }
        else{
            return .ImageJPEG
        }
        
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyInputFormatToDubble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        if let number = formatter.number(from: self) {
           return number.doubleValue
        }else{
            return nil
        } 
    }
}
