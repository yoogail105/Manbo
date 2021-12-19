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
            //read는 감별할 수 없다.
            if success {
                print("허용여부는 \(self.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) ==  .sharingDenied)")

                    print("yesss")
                    //code
                    print("허용했음.")
                    self.getTodayStepCounts()
                    self.getThisWeekStepCounts()
                    self.getThisMonthStepCounts()
                    self.getNDaysStepCounts(number: 30)
       } else {
                print("퍼미션뷰를 보지 못했다.")
            }
        }
    }
    
    func calculateDailyStepCountForPastWeek() {
        
    }

    
    func getNDaysStepCounts(number: Int) {
        self.getToalStepCounts(passedDays: number, completion: { (result) in
            DispatchQueue.main.async {
                if result == 0 {
                    UserDefaults.standard.healthKitAuthorization = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noHealthKitAuthorizationNotification"), object: nil)
                    
                } else {
                    UserDefaults.standard.healthKitAuthorization = true
                }
                // self.averageSevenDaysStepCounts = sevenDaysTotalStepCount / 7
                
            }
        })
    }
    
    func getTodayStepCounts()  {
        self.getToalStepCounts(passedDays: 0) { (result) in
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
            DispatchQueue.main.async {
                UserDefaults.standard.weekStepCount = Int(result)
                // self.averageThisWeekStepCounts = thisWeekTotalStepCount / 7
                
            }
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
        let userDefaults = UserDefaults.standard
        //let realm = try! Realm()
        

        let today = Date()
        dateFormatter.basicDateSetting()
        var totalSetpCountArray = [Int]()
        let pinDate = today.getPinDate()
    
        let startDate = calendar.date(byAdding: .day, value: -passedDays, to: pinDate)!
        //엔드: 오늘 기준시간으로부터 24시간 후까지
        let endDate = calendar.date(byAdding: .hour, value: 24, to: pinDate)!
        
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startDate,
                                                intervalComponents: interval)
        
        var totalCount = 0.0
        query.initialResultsHandler = {
            query, result, Error in
            var dayCount = 0.0
            var currentDate = startDate
            
            let goal = userDefaults.stepsGoal!
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to:endDate) { (statistic, value) in
                    let realm = try! Realm()
                    var filterdTask: Results<UserReport>?
                    let todayReport = dateFormatter.simpleDateString(date: today)
                    if let count = statistic.sumQuantity() {
                        //step가져오기(double)
                        dayCount = count.doubleValue(for: HKUnit.count())
                        totalSetpCountArray.append(Int(dayCount))
                        totalCount += dayCount
                        let savedDate = dateFormatter.simpleDateString(date: currentDate)
                        filterdTask =  realm.objects(UserReport.self).filter("date CONTAINS [c] '\(savedDate)'")
                        //realm 에 저장하기! -> func
                        
                        let task = UserReport(date: savedDate,
                                              stepCount:Int(dayCount),
                                              stepGoal: goal,
                                              goalPercent: dayCount / Double(goal))
                        if filterdTask?.count == 0 {
                            try! realm.write {
                                realm.add(task)
                            }
                            print("add success")
                        } else if savedDate == todayReport {
                            try! realm.write {
                                filterdTask?.first?.stepCount = Int(dayCount)
                                filterdTask?.first?.goalPercent = dayCount / Double(goal)
                            }
                            print("update success")
                        }
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                    }
                    DispatchQueue.main.async {
                        completion(totalCount)
                        
                    }
                }
            }
            // print(totalCount)
        }
        self.execute(query)
    }
    
}

