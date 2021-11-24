//
//  realmData.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/25.
//


import Foundation
import RealmSwift

class UserReport: Object {
    
    @Persisted var date = Date()
    @Persisted var stepCount: Int
    @Persisted var stepGoal: Int
    @Persisted var goalPercent: Double
    
    //PK(필수): Int, String, UUID, objectID
    @Persisted(primaryKey: true) var _id : ObjectId
    
    convenience init(date: Date, stepCount:Int,stepGoal: Int, goalRagoalPercentte: Double) {
        self.init()
        
        self.date = date
        self.stepCount = stepCount
        self.stepGoal = stepGoal
        self.goalPercent = goalPercent
    }
 
    // 퍼센트를 계산해서 넣으면 추후 변경이 어려우므로 percent를 그대로 넣기로 함.
//    enum GoalRate: String {
//        case row
//        case middle
//        case high
//        case complete
//
//    }
}
