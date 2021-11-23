//
//  HealthKitManager.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/23.
//

//
//import Foundation
//import HealthKit
//import UIKit
//
//class HealthKitManager: UIViewController {
//    // HKHelathStore: 헬스킷의 모든 데이터의 허용을 관리하는 클래스
//    let healthStore = HKHealthStore()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        auchorizeHealthKitinApp()
//
//      
//
//    }
//    func auchorizeHealthKitinApp() {
//    let typeToShare: HKQuantityType? = HKObjectType.quantityType(forIdentifier: .stepCount)
//        let typeToRead: HKQuantitySample? = HKQuantitySample.init(type:, quantity: ., start: <#T##Date#>, end: <#T##Date#>)
//        // 권한요청을 위한 두개의 파라미터: toshare: write, read: read
//        self.healthStore.requestAuthorization(toShare: <#T##Set<HKSampleType>?#>, read: <#T##Set<HKObjectType>?#>, completion: <#T##(Bool, Error?) -> Void#>)
//    }
//
//}



