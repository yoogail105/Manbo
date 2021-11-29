//
//  UIButton+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/22.
//

import UIKit

extension UIButton {
    
    func settingButtonUI() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.cornerRounded(cornerRadius: 10)
        self.setTitle("수정", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }
    
    func activeButtonColor(isActive: Bool) {
        self.backgroundColor = isActive ? UIColor.appColor(.mainGreen) : UIColor.systemGray
    }
}
