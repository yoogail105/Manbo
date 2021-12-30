//
//  UIView+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/18.
//

import UIKit

extension UIView {
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    func cornerRounded(cornerRadius: CGFloat) {
       // self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    
    func maskedCornerRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        cornerRounded(cornerRadius: cornerRadius)
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }

    //onboarding
    static func loadFromNib<T>() -> T? {
        let identifier = String(describing: T.self)
        let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first
        return view as? T
    }
    
    func customAlertSetting() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }
    
    func bannerSetting() {
        
    }
}

