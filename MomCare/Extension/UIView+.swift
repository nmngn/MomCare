//
//  UIView+.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    func makeBorderColor() {
        self.layer.do {
            $0.borderWidth = 0.5
            $0.borderColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 0.5).cgColor
        }
    }
    
    func makeShadow() {
        self.layer.do {
            $0.masksToBounds = false
            $0.shadowColor = UIColor(red: 1, green: 18, blue: 34, alpha: 0.05).cgColor
            $0.shadowOpacity = 1
            $0.shadowOffset = CGSize(width: 0, height: 2)
            $0.shadowRadius = 4
        }
    }
}
