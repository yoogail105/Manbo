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
}

extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .mainGreen:
            return #colorLiteral(red: 0.5058823529, green: 0.6431372549, blue: 0.4431372549, alpha: 1)
        case .borderLightGray:
            return #colorLiteral(red: 0.9098039216, green: 0.8980392157, blue: 0.9294117647, alpha: 1)
        }
    }
    
}
/*
 let green = UIColor(hex: 0x1faf46)
 let red = UIColor(hex: 0xfe5960)
 let blue = UIColor(hex: 0x0079d5)
 
 addAlpha
 let semitransparentBlack = UIColor(rgb: 0x000000).withAlphaComponent(0.5)
 */
