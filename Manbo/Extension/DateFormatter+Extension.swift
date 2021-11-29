//
//  DateFormatter+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/27.
//

import UIKit

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
    
    func simpleTimeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        
        return dateFormatter.string(from: date)
    }
}
