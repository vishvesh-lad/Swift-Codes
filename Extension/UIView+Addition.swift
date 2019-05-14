//
//  UIView+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension UIView {
    //Drop shadow on UIView
    func dropShadow(color: UIColor?, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //Drop shadow on UIView
    func shadow(color: UIColor?, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        let shadowView = UIView()
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = color?.cgColor
        shadowView.layer.shadowOffset = offSet
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowPath = shadowPath.cgPath
        shadowView.clipsToBounds = true
        
        self.addSubview(shadowView)
    }
    
    
    //Set Rounded corners using UIBezierPath
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    //Show Custom Toast for custom view
    func showCustomToastForCustomView(message: String?){
        //Show toast
        if let msg = message, msg.count > 0
        {
            self.hideAllToasts()
            self.makeToast(msg, duration: 3.0, point: CGPoint(x: (self.center.x) , y: (self.center.y) ), title: nil, image: nil, style: ToastStyle.init(), completion: nil)
        }
    }
    
    func animateView(hidden: Bool) {
        if self.isHidden != hidden{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.alpha = hidden ? 0.0 : 1.0
                self.isHidden = hidden
            }, completion: nil)
        }
    }
    
    // Show Custom View
    func showCustomViewPopup(passData1:String, passData2: String, btnCloseClick: @escaping () -> (), btnOkClick: @escaping (_ finalData:String) -> ()) {
        let alertView = Bundle.main.loadNibNamed(CustomViewIdentifiers.CustomPopupView, owner: self, options: nil)?[0] as! CustomPopupView
        
        alertView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        alertView.passData1 = passData1
        alertView.passData2 = passData2
        alertView.btnCloseClick = {
            btnCloseClick()
        }
        
        alertView.btnOkClick = {
            (finalData) in
            btnOkClick(finalData)
        }
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(alertView)
    }
}
