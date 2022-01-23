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
        case firstLaunchDate
        case healthKitAuthorization
        case name
        case stepGoal
        case resetTime
        case notiTime
        case lastConnection
        case setpPercent
        case weekStepCount
        case monthStepCount
        case currentStepCount
        
    }
    
    // Onboarding에서 start버튼 누르면
    var hasOnboarded: Bool {
        get { bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)}
    }
    
    var firstLaunchDate: Date? {
        get { return UserDefaults.standard.object(forKey: "firstLaunchDate") as? Date}
        set { setValue(newValue, forKey: UserDefaultsKeys.firstLaunchDate.rawValue)}
    }
    
    var healthKitAuthorization: Bool {
        get { bool(forKey: UserDefaultsKeys.healthKitAuthorization.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.healthKitAuthorization.rawValue)}
    }
    
    var lastConnection: String? {
        get { string(forKey: UserDefaultsKeys.lastConnection.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.lastConnection.rawValue)}
    }
    
     var name: String? {
         get { string(forKey: UserDefaultsKeys.name.rawValue)}
         set { setValue(newValue, forKey: UserDefaultsKeys.name.rawValue)}
    }
    
     var stepsGoal: Int? {
         get { integer(forKey: UserDefaultsKeys.stepGoal.rawValue)}
         set { setValue(newValue, forKey: UserDefaultsKeys.stepGoal.rawValue)}
    }
    
    var currentStepCount: Int? {
        get { integer(forKey: UserDefaultsKeys.currentStepCount.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.currentStepCount.rawValue)}
   }
    
    var resetTime: Date? {
        get { return UserDefaults.standard.object(forKey: "resetTime") as? Date}
        set { setValue(newValue, forKey: UserDefaultsKeys.resetTime.rawValue)}
    }
    
    var notiTime: Date? {
        get { return UserDefaults.standard.object(forKey: "notiTime") as? Date}
        set { setValue(newValue, forKey: UserDefaultsKeys.notiTime.rawValue)}
    }

    var stepPercent: Double? {
        get {
            return Double(currentStepCount!) / Double(stepsGoal!)
        }
    }

    var weekStepCount: Int? {
        get { integer(forKey: UserDefaultsKeys.weekStepCount.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.weekStepCount.rawValue)}
   }
    var monthStepCount: Int? {
       get { integer(forKey: UserDefaultsKeys.monthStepCount.rawValue)}
        set { setValue(newValue, forKey: UserDefaultsKeys.monthStepCount.rawValue)}
   }

}
