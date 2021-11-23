//
//  HealthStore.swift
//  Pods
//
//  Created by minjoohehe on 2021/11/23.
//
//
//import Foundation
//import HealthKit
//import UIKit
//
//class HealthStore {
//    
//    var healthStore: HKHealthStore?
//    
//    init() {
//        //healthkit 접근 거부되었는지 허용되었는지 확인
//        if HKHealthStore.isHealthDataAvailable() {
//            healthStore = HKHealthStore()
//        }
//    }
//    
//    func authorizeHealthKit(completion: @escaping (Bool) -> Void) {
//        
//        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
////        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
////        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
//        
//        guard let healthStore = self.healthStore else { return completion(false)}
//        
//        healthStore.requestAuthorization(toShare: [], read: [stepType]) {(sucess, error) in
//            if(sucess) {
//                print("permission granted")
//                //self.latestHealthRate()
//               // self.getTodayTotalStepCounts()
//            }
//            
//        }
//    }
//
//    
//}
