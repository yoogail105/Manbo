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
        case 0.0 ..< 0.3:
            userImage = Manbo.manbo00
        case 0.3 ..< 0.5:
            userImage = Manbo.manbo01
        case 0.5 ..< 0.8:
            userImage = Manbo.manbo02
        case 0.8 ..< 1.0:
            userImage = Manbo.manbo03
        default:
            userImage = Manbo.manbo100
        }
        
        return userImage.rawValue
    }
    
    func showToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }

   
}



