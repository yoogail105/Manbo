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
        case healthKitAuthorization
        case name
        case stepGoal
        case resetTime
        case notiTime
        case lastConnection
        case setpPercent
        case weekStepCount
        case monthStepCount
        
    }
    
    // Onboarding에서 start버튼 누르면
    var hasOnbarded: Bool {
        get { bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
    }
    
    var healthKitAuthorization: Bool {
        get { bool(forKey: UserDefaultsKeys.healthKitAuthorization.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.healthKitAuthorization.rawValue)}
    }
    
    var lastConnection: Date? {
        get { return UserDefaults.standard.object(forKey: "lastConnection") as? Date}
        set { UserDefaults.standard.set(newValue, forKey: "lastConnection")}
    }
    
     var name: String? {
        get { return UserDefaults.standard.string(forKey: "name")}
        set { UserDefaults.standard.set(newValue, forKey: "name")}
    }
    
     var stepsGoal: Int? {
        get { return UserDefaults.standard.integer(forKey: "stepsGoal")}
        set {
            newValue == 0 ? 3000 : newValue
            UserDefaults.standard.set(newValue, forKey: "stepsGoal")}
    }
    
    var currentStepCount: Int? {
       get { return UserDefaults.standard.integer(forKey: "currentStepCount")}
       set { UserDefaults.standard.set(newValue, forKey: "currentStepCount")}
   }
    
    var resetTime: Date? {
        get { return UserDefaults.standard.object(forKey: "resetTime") as? Date}
        set { UserDefaults.standard.set(newValue, forKey: "resetTime")}
    }
    
    var notiTime: Date? {
        get { return UserDefaults.standard.object(forKey: "notiTime") as? Date}
        set { UserDefaults.standard.set(newValue, forKey: "notiTime")}
    }

    var setpPercent: Double? {
        get {
            let result = Double(currentStepCount!) / Double(stepsGoal!)
            return result * 100
        }
    }

    var weekStepCount: Int? {
       get { return UserDefaults.standard.integer(forKey: "weekStepCount")}
       set { UserDefaults.standard.set(newValue, forKey: "weekStepCount")}
   }
    var monthStepCount: Int? {
       get { return UserDefaults.standard.integer(forKey: "monthStepCount")}
       set { UserDefaults.standard.set(newValue, forKey: "monthStepCount")}
   }
    
}
