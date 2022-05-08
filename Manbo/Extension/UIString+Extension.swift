//
//  UIString+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import Foundation

extension String {
    var localized: String {
       return NSLocalizedString(self, comment: "")
    }
    
    
    func localized(tableName: String = "Localization") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: "")
    }
}
