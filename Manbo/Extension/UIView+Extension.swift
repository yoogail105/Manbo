//
//  UIView+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/18.
//

import UIKit

extension UIView {

    func cornerRounded(cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func maskedCornerRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        cornerRounded(cornerRadius: cornerRadius)
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    static func loadFromNib<T>() -> T? {
        let identifier = String(describing: T.self)
        let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first
        return view as? T
    }
}

