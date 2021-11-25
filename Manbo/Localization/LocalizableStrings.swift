//
//  LocalizableStrings.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import Foundation

enum  LocalizableStrings: String {

    // MainView
    case welcome_text
    case goal_steps
    case data_backup
    case restore
        
    // SettingView
    
    
    var localized: String {
        return self.rawValue.localized()
    }
//    NSLocalizedString("goal_steps", comment: "목표 걸음 수")
    var LocalizedMain: String {
        return self.rawValue.localized(tableName: "Localizable")
    }
    var localizedSetting: String {
        return self.rawValue.localized(tableName: "Setting")
    }
    
}

