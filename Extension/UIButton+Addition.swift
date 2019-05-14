//
//  UIButton+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 1) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}
