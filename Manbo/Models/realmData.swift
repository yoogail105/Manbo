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
    @Persisted var Success: Bool // 달성여부
    
    //PK(필수): Int, String, UUID, objectID
    @Persisted(primaryKey: true) var _id : ObjectId
    
    convenience init(date: Date, stepCount:Int,stepGoal: Int, Success: Bool) {
        self.init()
        
        self.date = date
        self.stepCount = stepCount
        self.stepGoal = stepGoal
        self.Success = false
    }
}
