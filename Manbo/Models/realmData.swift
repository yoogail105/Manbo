//
//  realmData.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/25.
//


import Foundation
import RealmSwift

class UserReport: Object {
    
    @Persisted var date: String
    @Persisted var stepCount: Int
    @Persisted var stepGoal: Int
    @Persisted var goalPercent: Double
   // @Persisted var success: Bool
    override static func primaryKey() -> String? {
        return "date"
    }
    convenience init(date: String, stepCount:Int,stepGoal: Int, goalPercent: Double) {
        self.init()
        
        self.date = date
        self.stepCount = stepCount
        self.stepGoal = stepGoal
        self.goalPercent = goalPercent
        //self.success = false
    }
}
