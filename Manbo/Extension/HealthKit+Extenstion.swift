//
//  HealthKit+Extenstion.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/28.
//

import UIKit
import HealthKit
import RealmSwift


extension HKHealthStore {
    
    func authorizedHealthKIt() {
        let healthKitTypes = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        self.requestAuthorization(toShare: nil, read: [healthKitTypes]) { success, Error in
            // 아래의 success는 요청하는 뷰가 성공적으로 띄워졌는지에 관한 것.
            if success {
                let authorizationStatus = self.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
                
                if authorizationStatus != .notDetermined {
                    // read: 승인 or 거부 -> 확인할 수 없으므로 얻어진 걸음수가 0걸음이면 거부로 간주
                    DispatchQueue.global().async {
                        print(#function)
                        self.getTodayStepCounts()
                        self.getNDaysStepCounts(number: 30)
                        self.getThisWeekStepCounts()
                    }
                }
                
            }
        }
    }
    
    func getNDaysStepCounts(number: Int) {
        
        self.getToalStepCounts(passedDays: number, completion: { (result) in
            print(#function)
            print(result)
            
            if result == 0 {
                UserDefaults.standard.currentStepCount = 0
                UserDefaults.standard.healthKitAuthorization = false
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStepCountNotification"), object: nil, userInfo: ["newCurrentStepCount": 0])
                }
                
            } else {
                UserDefaults.standard.healthKitAuthorization = true
                // self.averageSevenDaysStepCounts = sevenDaysTotalStepCount / 7
                
            }
        })
    }
    
    func getTodayStepCounts()  {
        self.getToalStepCounts(passedDays: 0) { (result) in
            print(#function)
            DispatchQueue.main.async {
                let currentStepCount = Int(result)
                UserDefaults.standard.currentStepCount = currentStepCount
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStepCountNotification"), object: nil, userInfo: ["newCurrentStepCount": currentStepCount])
            }
        }
    }
    
    func getThisWeekStepCounts() {
        
        let passedWeekday = Date().weekday
        self.getToalStepCounts(passedDays: passedWeekday - 1, completion: { (result) in
            print(#function)
            UserDefaults.standard.weekStepCount = Int(result)
            // self.averageThisWeekStepCounts = thisWeekTotalStepCount / 7
            
            
        })
    }
    
    func getThisMonthStepCounts() {
        
        self.getToalStepCounts(passedDays: Date().day, completion: { (result) in
            DispatchQueue.main.async {
                UserDefaults.standard.monthStepCount = Int(result)
                // self.averageThisMonthStepCounts = thisWeekTotalStepCount / today.day
            }
        })
    }
    
    func getMonthStepCounts() {
        self.getToalStepCounts(passedDays: 0) { (result) in
            DispatchQueue.main.async {
                // 결과 받아올 곳(혹은 리턴하기)
            }
        }
    }
    
    
    func getToalStepCounts(passedDays: Int, completion: @escaping (Double) -> Void) {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let today = Date()
        dateFormatter.basicDateSetting()
        var pinDate = today.getPinDate()
        let isTodayCountStarted = isResetTimePassed(now: today, user: pinDate)
        
        if !isTodayCountStarted {
            pinDate -= 86400
        }
        
        let startDate = calendar.date(byAdding: .day, value: -passedDays, to: pinDate)!
        let endDate = calendar.date(byAdding: .hour, value: 24, to: pinDate)!
        
        
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        var interval = DateComponents()
        interval.hour = 24
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, statisticsCollection, Error in
            var totalCount = 0.0
            if let statisticsCollection = statisticsCollection {
                totalCount = self.saveResultAndUpdateUIFromStatistics(passedDays: passedDays, statisticsCollection)
            }
            completion(totalCount)
        }//:  query.initialResultsHandler
        
        query.statisticsUpdateHandler = { [weak self] query, statistics, statisticsCollection, error in
            var totalCount = 0.0
            if let statisticsCollection = statisticsCollection {
                totalCount = self?.saveResultAndUpdateUIFromStatistics(passedDays: passedDays, statisticsCollection) ?? 0
            }
            completion(totalCount)
        }
        
        self.execute(query)
    }
    
    func saveResultAndUpdateUIFromStatistics(passedDays: Int, _ statisticsCollection: HKStatisticsCollection) -> Double {
        var totalCount = 0.0
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let userDefaults = UserDefaults.standard
        let today = Date()
        dateFormatter.basicDateSetting()
        
        // pindate중복 합치기
        var pinDate = today.getPinDate()
        let isTodayCountStarted = isResetTimePassed(now: today, user: pinDate)
        if !isTodayCountStarted {
            pinDate -= 86400
        }
        
        let startDate = calendar.date(byAdding: .day, value: -passedDays, to: pinDate)!
        let endDate = calendar.date(byAdding: .hour, value: 24, to: pinDate)!
        var dayCount = 0.0
        var currentDate = startDate
        let goal = userDefaults.stepsGoal!
        
        let realm = try! Realm()
        var filteredTask: Results<UserReport>?
        var todayReport = dateFormatter.simpleDateString(date: today)
        if !isTodayCountStarted {
            todayReport = dateFormatter.simpleDateString(date: calendar.date(byAdding: .day, value: -1, to: today)!)
        }
        
        statisticsCollection.enumerateStatistics(from: startDate, to:endDate) { (statistic, value) in
            dayCount = statistic.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            totalCount += dayCount
            let savedDate = dateFormatter.simpleDateString(date: currentDate)
            filteredTask =  realm.objects(UserReport.self).filter("date CONTAINS [c] '\(savedDate)'").sorted(byKeyPath: "date", ascending: false)
            
            //realm 에 저장하기! -> func
            let task = UserReport(date: savedDate,
                                  stepCount:Int(dayCount),
                                  stepGoal: goal,
                                  goalPercent: dayCount / Double(goal))
            
            if currentDate == endDate {
                if filteredTask?.count != 0 {
                    if let nextDayTask = filteredTask?.first {
                        try! realm.write {
                            realm.delete(nextDayTask)
                        }
                    }
                }
            } else {
                if filteredTask?.count == 0 {
                    // 해당하는 날짜에 대한 정보가 없다.
                    try! realm.write {
                        realm.add(task)
                    }
                } else if filteredTask?.first?.date == userDefaults.lastConnection {
                    // lastConnect가 있으면 -> 같은 날이면 변경 완료
                    try! realm.write {
                        filteredTask?.first?.stepCount = Int(dayCount)
                        filteredTask?.first?.goalPercent = dayCount / Double(goal)
                    }
                } else if savedDate == todayReport {
                    //오늘이면 날짜 변경 완료
                    try! realm.write {
                        filteredTask?.first?.stepCount = Int(dayCount)
                        filteredTask?.first?.goalPercent = dayCount / Double(goal)
                    }
                    userDefaults.lastConnection = todayReport
                } else if filteredTask?.first?.date != userDefaults.lastConnection {
                    if (filteredTask?.first?.stepCount)! != task.stepCount {
                        try! realm.write {
                            filteredTask?.first?.stepCount = Int(dayCount)
                            filteredTask?.first?.goalPercent = dayCount / Double(goal)
                        }
                    }
                }
                
            } //: if문: endDate가 아닌 동안에 realm에 저장
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }//: statisticsCollection.enumerateStatistics(from: startDate, to:endDate)
        
        return totalCount
    }
    
    func isResetTimePassed(now: Date, user: Date) -> Bool {
        var isTodayCountStarted: Bool
        if now.hour == user.hour && now.minute >= user.minute {
            isTodayCountStarted = true
        } else if now.hour > user.hour {
            isTodayCountStarted = true
        } else {
            isTodayCountStarted = false
        }
        return isTodayCountStarted
    }
}
