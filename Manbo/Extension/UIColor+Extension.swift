//
//  UIColor+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/18.
//

import UIKit

extension UIColor {
    
    convenience init(hex:Int, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}
/*
 let green = UIColor(hex: 0x1faf46)
 let red = UIColor(hex: 0xfe5960)
 let blue = UIColor(hex: 0x0079d5)
 */
