//
//  Notification+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

extension NSNotification.Name {
    static let goalNotification = NSNotification.Name("changeGoalNotification")
    static let nameNotification = NSNotification.Name("changeNameNotification")
    static let stepNotification = NSNotification.Name("changeResetTimeNotification")
    static let updateStepNotification = NSNotification.Name("changeStepCountNotification")
    static let updateImageNotification = NSNotification.Name("changeImageNotification")
    static let offNotification = NSNotification.Name("turnOffNotification")
    static let isHiddenNotiTimeLabel = NSNotification.Name("isHiddenNotiTimeLabel")
    static let ifNoHealthKitAuthorization = NSNotification.Name("noHealthKitAuthorizationNotification")
}
