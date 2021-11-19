//
//  LocalizableStrings.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import Foundation

enum  LocalizableStrings: String {

    case welcome_text
    case goal_steps
    case data_backup
    case restore
    
    var localized: String {
        return self.rawValue.localized()
    }

    
    var localizedSetting: String {
        return self.rawValue.localized(tableName: "Setting")
    }
    
}

