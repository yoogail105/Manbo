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
    
    // 헬스킷 허용 여부
    func ishealthKitAuthorized() -> Bool {
        if (self.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized) {
            return true
        }
        else {
            return false
        }
    }
    
    // 헬스킷 허용 요청
    func authorizeHealthKit() {
        print("main: ", #function)
        let healthKitTypes = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!])
        //let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        self.requestAuthorization(toShare: [], read: healthKitTypes) { (sucess, error) in
            if(sucess) {
                print("HealthKit: permission granted")
                UserDefaults.standard.healthKitAuthorization = true
            } else {
                print("헬스킷 거부됨 -> 얼럿 필요")
                UserDefaults.standard.healthKitAuthorization = false
            }
        }
        
        
    }
    
    // 나중에 활용
    func getSevenDaysStepCounts() {
        self.getToalStepCounts(passedDays: 6, completion: { (result) in
            DispatchQueue.main.async {
                // self.averageSevenDaysStepCounts = sevenDaysTotalStepCount / 7
                
            }
        })
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
    
    
    func getToalStepCounts(passedDays: Int, completion: @escaping (Double) -> Void) {
        let dateFormatter = DateObject.dateFormatter
        let calendar = DateObject.calendar
        
        //let realm = try! Realm()
        
        
        let goal = UserDefaults.standard.stepsGoal!
        let today = Date()
        dateFormatter.basicDateSetting()
        //var totalCount = 0.0
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
            let goal = UserDefaults.standard.stepsGoal!
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to:endDate) { (statistic, value) in
                    let realm = try! Realm()
                    let tasks: Results<UserReport>!
                    tasks = realm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
                    if let count = statistic.sumQuantity() {
                        //step가져오기(double)
                        dayCount = count.doubleValue(for: HKUnit.count())
                        totalSetpCountArray.append(Int(dayCount))
                        totalCount += dayCount
                        let savedDate = dateFormatter.simpleDateString(date: currentDate)
                        //realm 에 저장하기! -> func
                       
                        
                        let task = UserReport(date: "2023",
                                              
                                              stepCount:Int(dayCount),
                                              stepGoal: goal,
                                              goalPercent: dayCount / Double(goal))
                        print(task)
                        print(dateFormatter.simpleDateString(date: currentDate))
                        
                        if realm.objects(UserReport.self).filter("date CONTAINS [c] '\(savedDate)'").count != 0{
                        try! realm.write {
                            realm.add(task)
                            print("success")

                        }
                        }
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                        // print("걸음더하기: \(dayCount)")
                    }
                    //return
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

