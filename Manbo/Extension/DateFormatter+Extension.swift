//
//  DateFormatter+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/27.
//

import UIKit

class DateObject {
    static let dateFormatter = DateFormatter()
    static let calendar = Calendar.current

    private init() { }
}

extension DateFormatter {
    
    func basicDateSetting() {
        DateFormatter().timeZone = calendar.timeZone
        DateFormatter().locale = calendar.locale
    }
    
    func simpleDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
