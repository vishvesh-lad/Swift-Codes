//
//  UINavigationController+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension UINavigationController{
    func getSpecificVCFromNavigationStack(popIfNotFound: Bool = true, viewController: AnyClass) -> UIViewController? {
        //Pop to specific view controller
        var isVCFound = false
        let viewControllers: [UIViewController] = self.viewControllers
        for vc in viewControllers {
            if vc.isKind(of: viewController) {
                isVCFound = true
                return vc
            }
        }
        
        if isVCFound == false && popIfNotFound
        {
            self.popViewController(animated: true)
        }
        return nil
    }
}
