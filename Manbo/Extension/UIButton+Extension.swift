//
//  UIButton+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/22.
//

import UIKit

extension UIButton {
    
    func settingButtonUI(title: String) {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.cornerRounded(cornerRadius: 10)
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }
    
    func activeButtonColor(isActive: Bool) {
        self.backgroundColor = isActive ? UIColor.appColor(.mainGreen) : UIColor.systemGray
    }
    
    func calendarButtonUI(title: String) {
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        self.cornerRounded(cornerRadius: 8)
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.systemGray, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }
    
    func calendarColorButtonUI(title: String) {
        self.setTitleColor(UIColor.appColor(.mainGreen), for: .normal)
        self.layer.borderColor = UIColor.appColor(.mainGreen).cgColor
        self.layer.borderWidth = 1
        self.cornerRounded(cornerRadius: 8)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }
}
