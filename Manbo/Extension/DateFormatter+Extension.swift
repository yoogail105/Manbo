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

//    func getResetTime() -> (hour: Int, minute: Int) {
//        print("main",#function)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        
//        //유저가 선택한 시간 가져오기
//        let resetTimeString = UserDefaults.standard.resetTime!
//        let resetTime = dateFormatter.date(from: resetTimeString)
//        var hour = calendar.component(.hour, from: resetTime!)
//        midnightDate.hour = calendar.component(.minute, from: resetTime!)
//        
//        return (hour: resetHour, minute: resetMinute)
//    }
//    
//    func getUserSetpCounts() {
//        
//    }
//    
//   
//
    var year: Int {
        get {
            Calendar.current.component(.year, from: Date())
        }
    }
//    
    // 기준 데이트 구하기: 오늘 날짜 00시 00분
    func getPinDate(todayMidnight: Date) {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        DateFormatter().timeZone = calendar.timeZone
        DateFormatter().locale = calendar.locale
        
        
        let year = calendar.component(.year, from: todayMidnight)
        let month = calendar.component(.month, from: todayMidnight)
        let day = calendar.component(.day, from: todayMidnight)
        let weekDay = calendar.component(.weekday, from: todayMidnight) //1=sun, 7=sat
        print("요일 : \(weekDay)")
//        let dateComponents = DateComponents(year: year, month: month, day: day, hour: midnightDate.hour, minute: midnightDate.minute)
//    }
}
}
