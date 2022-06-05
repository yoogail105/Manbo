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
    
    // 이번달 첫날
    func getPinDate(startMonth: Int) -> Date {
        
        let dateComponents = DateComponents(year: self.year, month: startMonth, day: 1, hour: UserDefaults.standard.resetTime!.hour, minute: UserDefaults.standard.resetTime!.minute)
        let pinDate = Calendar.current.date(from: dateComponents)
        
        return pinDate!
    }
    
    func getPinDate() -> Date {
        
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day, hour: UserDefaults.standard.resetTime!.hour, minute: UserDefaults.standard.resetTime!.minute)
        let pinDate = Calendar.current.date(from: dateComponents)
        
        return pinDate!
    }
    
    // 이번달 1일 구하기 with 설정 시간
    func startOfMonth() -> (startOfThisMonth: Date, startOfLastMonth: Date, startOfNextMonth: Date, endOfThisMonth: Date) {
        
        let calendar = Calendar.current
        
        
        let month = self.month
        
        // 이번달 1일
        let startOfThisMonth = self.getPinDate(startMonth: month)
        
        // 지난달 1일
        let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfThisMonth)
        
        //다음달 1일
        let startOfNextMonth = calendar.date(byAdding: .month, value: +1, to: startOfThisMonth)
        
        //이번달 마지막
        let endOfThisMonth = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth!)
    
        return (startOfThisMonth,  startOfLastMonth!,  startOfNextMonth!, endOfThisMonth!)
    }
}
