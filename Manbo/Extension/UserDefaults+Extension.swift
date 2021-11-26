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
        case name
        case stepGoal
        case resetTime
        case notiTIme
    }
    
    // Onboarding에서 start버튼 누르면
    var hasOnbarded: Bool {
        get { bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
    }
    
    
     var name: String? {
        get { return UserDefaults.standard.string(forKey: "name")}
        set { UserDefaults.standard.set(newValue, forKey: "name")}
    }
    
     var stepsGoal: Int?{
        get { return UserDefaults.standard.integer(forKey: "stepsGoal")}
        set { UserDefaults.standard.set(newValue, forKey: "stepsGoal")}
    }
    
    var currentStepCount: Int? {
       get { return UserDefaults.standard.integer(forKey: "currentStepCount")}
       set { UserDefaults.standard.set(newValue, forKey: "currentStepCount")}
   }
    
     var resetTime: String? {
        get { return UserDefaults.standard.string(forKey: "resetTime")}
        set { UserDefaults.standard.set(newValue, forKey: "resetTime")}
    }
    
     var notiTime: String? {
        get { return UserDefaults.standard.string(forKey: "notiTime")}
        set { UserDefaults.standard.set(newValue, forKey: "notiTime")}
    }

    var setpPercent: Double? {
        get {
            let result = Double(currentStepCount!) / Double(stepsGoal!)
            return result * 100
        }
    }
}
