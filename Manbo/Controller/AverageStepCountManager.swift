//
//  AverageStepCountManager.swift
//  Manbo
//
//  Created by 성민주민주 on 2022/01/16.
//

import UIKit
import RealmSwift

class AverageStepCountManager {
    static let shared = AverageStepCountManager()
    
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    
    
    func calculateMonthlyAverageStepCount(year: Int, month: Int) -> Int {
        
        let monthString = String(format: "%02d", month)
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false).filter("date CONTAINS [c] '\(year)-\(monthString)'")
        
        var totalStepCount = 0
        
        tasks.forEach { task in
            print(task.date)
            print(task.stepCount)
            totalStepCount += task.stepCount
        }
    
        //print("\(year)년 \(monthString)월 totalStepCount:", totalStepCount)
        
        let monthlyAverageStepCount = totalStepCount / tasks.count
        
        return monthlyAverageStepCount
    
    }
    
    
}