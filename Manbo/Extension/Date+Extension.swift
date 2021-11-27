//
//  UIInt+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/27.
//

import UIKit
extension Date {
    

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    func getPinDate(startDay: Int) -> Date {
        
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: UserDefaults.standard.resetTime!.hour, minute: UserDefaults.standard.resetTime!.minute)
        let pinDate = Calendar.current.date(from: dateComponents)
        
        return pinDate!
    }
    
    func getPinDate() -> Date {
        
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: UserDefaults.standard.resetTime!.hour, minute: UserDefaults.standard.resetTime!.minute)
        let pinDate = Calendar.current.date(from: dateComponents)
        
        return pinDate!
    }
    
    func endDate() -> Date {
        
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: UserDefaults.standard.resetTime!.hour, minute: UserDefaults.standard.resetTime!.minute)
        let pinDate = Calendar.current.date(from: dateComponents)
        
        return pinDate!
    }
    
    
    //오늘
    func todayDateSet() -> Date {
        let startDate = Calendar.current.date(byAdding: .day, value: 0, to: self)!
        
        return startDate
    }
    
//    endDate = calendar.date(byAdding: .hour, value: 24, to: pinDate!) //오늘의 기록 구하기
//
//    // 이번주
//    let passedWeekday = today.weekday - 1
//    startDate = calendar.date(byAdding: .day, value: -passedWeekday, to: pinDate!)
//    endDate = calendar.date(byAdding: .hour, value: 24, to: pinDate!)
//
//
    
}
