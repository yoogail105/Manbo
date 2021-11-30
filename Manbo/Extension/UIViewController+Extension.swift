//
//  UIViewController+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/21.
//

import UIKit
extension UIViewController {
////
//    static var identifier: String {
//        return String(describing: self)
//    }
    
//    static func instantiate() -> Self {
//        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//        return storyboard.instantiateViewController(identifier: identifier) as! Self
//    }
    func setUserImage(userPercent: Double) -> String {
        var userImage = Manbo.manbo100
        switch userPercent {
        case 0.0 ..< 30.0:
            userImage = Manbo.manbo00
        case 30.0 ..< 50.0:
            userImage = Manbo.manbo01
        case 50.0 ..< 80.0:
            userImage = Manbo.manbo02
        case 80.0 ..< 100.0:
            userImage = Manbo.manbo03
        default:
            userImage = Manbo.manbo100
        }
        
        return userImage.rawValue
}

}



