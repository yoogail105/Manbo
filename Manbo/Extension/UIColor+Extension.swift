//
//  UIColor+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/18.
//

import UIKit

enum AssetsColor {
    case mainGreen
    case borderLightGray
    case mainBlue
}

extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .mainGreen:
            return #colorLiteral(red: 0.5058823529, green: 0.6431372549, blue: 0.4431372549, alpha: 1)
        case .borderLightGray:
            return #colorLiteral(red: 0.9098039216, green: 0.8980392157, blue: 0.9294117647, alpha: 1)
        case .mainBlue:
            return #colorLiteral(red: 0.4156862745, green: 0.5490196078, blue: 0.7019607843, alpha: 1)
      
        }
    }
    
    convenience init(hex value: Int, alpha: CGFloat = 1.0) {
        self.init(
        red: CGFloat((value & 0xFF0000) >> 16 ) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8 ) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}

/*
 let green = UIColor(hex: 0x1faf46)
 let red = UIColor(hex: 0xfe5960)
 let blue = UIColor(hex: 0x0079d5)
 
 addAlpha
 let semitransparentBlack = UIColor(rgb: 0x000000).withAlphaComponent(0.5)
 */
