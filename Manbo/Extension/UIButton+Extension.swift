//
//  UIButton+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/22.
//

import UIKit

extension UIButton {
    
    
    func activeButtonColor(isActive: Bool) {
        self.backgroundColor = isActive ? UIColor.appColor(.mainGreen) : UIColor.systemGray
    }
}
