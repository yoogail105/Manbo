//
//  DateFormatter+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/27.
//

import Foundation

extension DateFormatter {
    
    func basicDateSetting() {
        DateFormatter().timeZone = calendar.timeZone
        DateFormatter().locale = calendar.locale
    }
}
