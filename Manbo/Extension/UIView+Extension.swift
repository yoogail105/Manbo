//
//  UIView+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/18.
//

import UIKit

extension UIView {

    func cornerRounded(cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func maskedCornerRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        cornerRounded(cornerRadius: cornerRadius)
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
}

