//
//  CALayer+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension CALayer {
    //Add border on defined edges and dropshadow
    func addBorder(accessibilityHint: String?, edge: UIRectEdge, color: UIColor, thickness: CGFloat, isDropShadow: Bool) {
        let border = CALayer()
        
        //Remove layer in case view reload or change its frame conditionally
        self.removeLayer(accessibilityHint: accessibilityHint)
        border.accessibilityHint = accessibilityHint
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        //Drop shadow with Edge border
        if isDropShadow {
            border.masksToBounds = false
            border.shadowOffset = CGSize(width: 0, height: 1)
            border.shadowColor = UIColor.CustomColor.CustomShadow?.cgColor
            border.shadowOpacity = 1
            border.shadowRadius = 1
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
    
    func removeLayer(accessibilityHint: String?){
        if accessibilityHint != nil
        {
            for layer in self.sublayers ?? [CALayer]()
            {
                if layer.accessibilityHint == accessibilityHint
                {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
