//
//  UserDefaults+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/21.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    // Onboarding에서 start버튼 누르면
    var hasOnbarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
