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
                    DispatchQueue.main.sync {
                        self.getNDaysStepCounts(number: 30)
                        self.getTodayStepCounts()
                        self.getThisWeekStepCounts()
                    }
                   
                }
                
            } else {
                //퍼미션 뷰 보지 못함
            }
        }
    }
    
    func calculateDailyStepCountForPastWeek() {
        
    }
    
    
    func getNDaysStepCounts(number: Int) {
        
        self.getToalStepCounts(passedDays: number, completion: { (result) in
            print(#function)
//            DispatchQueue.main.async {
                if result == 0 {
                    print("결과는 0")
                    UserDefaults.standard.healthKitAuthorization = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noHealthKitAuthorizationNotification"), object: nil)
                    
                } else {
                    UserDefaults.standard.healthKitAuthorization = true
                }
                // self.averageSevenDaysStepCounts = sevenDaysTotalStepCount / 7
                
//            }
        })
    }
    
    func getTodayStepCounts()  {
        self.getToalStepCounts(passedDays: 0) { (result) in
            print(#function)
//            DispatchQueue.main.async {
                let currentStepCount = Int(result)
                UserDefaults.standard.currentStepCount = currentStepCount
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStepCountNotification"), object: nil, userInfo: ["newCurrentStepCount": currentStepCount])
//            }
        }
    }
    
    
    
    
    
    func getThisWeekStepCounts() {
        
        let passedWeekday = Date().weekday
        self.getToalStepCounts(passedDays: passedWeekday - 1, completion: { (result) in
            print(#function)
            DispatchQueue.main.async {
                print("passedWeekday",passedWeekday)
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
        print("걸음 수 가져오기")
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let userDefaults = UserDefaults.standard
        //let realm = try! Realm()
        
        
        let today = Date()
        dateFormatter.basicDateSetting()
        var totalStepCountArray = [Int]()
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
                    var filteredTask: Results<UserReport>?
                    let todayReport = dateFormatter.simpleDateString(date: today)
                    if let count = statistic.sumQuantity() {
                        //step가져오기(double)
                        dayCount = count.doubleValue(for: HKUnit.count())
                        print("dayCount: \(dayCount)")
                        totalStepCountArray.append(Int(dayCount))
                        totalCount += dayCount
                        let savedDate = dateFormatter.simpleDateString(date: currentDate)
                        filteredTask =  realm.objects(UserReport.self).filter("date CONTAINS [c] '\(savedDate)'").sorted(byKeyPath: "date", ascending: false)
                        
                        //realm 에 저장하기! -> func
                        
                        let task = UserReport(date: savedDate,
                                              stepCount:Int(dayCount),
                                              stepGoal: goal,
                                              goalPercent: dayCount / Double(goal))
                        if filteredTask?.count == 0 {
                            // 해당하는 날짜에 대한 정보가 없다.
                            try! realm.write {
                                realm.add(task)
                            }
                            
                        } else if filteredTask?.first?.date != userDefaults.lastConnection {
                            
//                        else if userDefaults.lastConnection == "" {
                            
                            if (filteredTask?.first?.stepCount)! != task.stepCount {
                                try! realm.write {
                                    filteredTask?.first?.stepCount = Int(dayCount)
                                    filteredTask?.first?.goalPercent = dayCount / Double(goal)
                                }
                            }
                            
                        } else if filteredTask?.first?.date == userDefaults.lastConnection {
                            // lastConnect가 있으면 -> 같은 날이면 변경 완료
                            try! realm.write {
                                filteredTask?.first?.stepCount = Int(dayCount)
                                filteredTask?.first?.goalPercent = dayCount / Double(goal)
                            }

                            
                        } else if savedDate == todayReport {
                            try! realm.write {
                                filteredTask?.first?.stepCount = Int(dayCount)
                                filteredTask?.first?.goalPercent = dayCount / Double(goal)
                            }
                            userDefaults.lastConnection = todayReport
                            print(#function, "lastConnetcion: \(userDefaults.lastConnection!)")
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

