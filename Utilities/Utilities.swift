//
//  Utilities.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

class Utilities: NSObject {
    //MARK: Decorate view with border and corner radius
    class func decorateView(_ layer: CALayer, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?){
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    //MARK: Decorate view with corner radius and background color
    class func giveCornerRadiusAndBGColor(_ layer: CALayer, bgColor: UIColor) {
        layer.cornerRadius = layer.frame.width / 2
        layer.backgroundColor = bgColor.cgColor
    }
    
    //MARK: Decorate view with rounded corner radius
    class func setRoundedCornerRadius(_ layer: CALayer, borderColor: UIColor, borderWidth: CGFloat)
    {
        layer.cornerRadius = layer.frame.width / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
    }
    
    //MARK: Check internet connection
    static func checkInternetConnection() -> Bool
    {
        if(APIManager.sharedInstance.isConnectedToNetwork())
        {
            return true
        }else{
            return false
        }
    }
    
    //Show toast
    class func showCustomToast(message: String?) {
        if let msg = message, msg.count > 0
        {
            DispatchQueue.main.async {
                let topView = UIApplication.shared.keyWindow?.topMostWindowController()
                topView?.view.hideAllToasts()
                topView?.view.makeToast(msg, duration: 3.0, point: CGPoint(x: (topView?.view.center.x) ?? 0, y: (topView?.view.center.y) ?? 0), title: nil, image: nil, style: ToastStyle.init(), completion: nil)
            }
        }
    }
    
    //Show Alert on View Controller
    class func showAlertWithButtonsOnViewController(
        targetVC: UIViewController,
        title: String,
        message: String,
        yesClickclosure: @escaping () -> Void)
    {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        let CancelButton = UIAlertAction(
            title:"CANCEL",
            style: UIAlertAction.Style.cancel,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        
        let YesButton = UIAlertAction(
            title:"YES",
            style: UIAlertAction.Style.default,
            handler:
            {
                (alert: UIAlertAction!)  in
                yesClickclosure()
        })
        
        alert.addAction(CancelButton)
        alert.addAction(YesButton)
        targetVC.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Get trimmed string
    class func trimWhiteSpaces(_ stringToTrim: String) -> String {
        let string: String = stringToTrim
        let trimmedString: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    //MARK:- Validation
    class func isValidEmail(_ strEmail:String) -> Bool {
        //Validate email
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailRegEx2 = "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx2)
        return emailTest.evaluate(with: strEmail)
    }
    
    class func isValidCanadaZipCode(_ strZip:String) -> Bool {
        //Validate Zip
        //        let zipCodeRegEx = "[aAbBcCeEgGhHjJkKlLmMnNpPrRsStTvVxXyY]+[0-9]+[aAbBcCeEgGhHjJkKlLmMnNpPrRsStTvVxXyY]+[ ]+[0-9]+[aAbBcCeEgGhHjJkKlLmMnNpPrRsStTvVxXyY]+[0-9]"
        let zipCodeRegEx = "^(?!.*[DFIOQUdfioqu])[A-VXYa-vxy][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"
        
        let zipTest = NSPredicate(format:"SELF MATCHES %@", zipCodeRegEx)
        return zipTest.evaluate(with: strZip)
    }
}

