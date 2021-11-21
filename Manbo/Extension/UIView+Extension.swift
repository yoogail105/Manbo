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
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func maskedCornerRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        cornerRounded(cornerRadius: cornerRadius)
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }

}

