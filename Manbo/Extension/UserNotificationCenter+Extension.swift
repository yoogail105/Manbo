////
////  UserNotificationCenter+Extension.swift
////
////
////  Created by minjoohehe on 2021/11/30.
////
//
//import UIKit
//import UserNotifications
//
//extension UNUserNotificationCenter {
//
//
//    // MARK: - NOTIFICATION CENTER
//    // 권한 요청 -> 권한 요청 팝업
//    func requestNotificationAuthorization() {
//        let userNotificationCenter = UNUserNotificationCenter.current()
//
//        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
//        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
//            if success {
//                self.sendNotification()
//            }
//        }
//    }
//
//    // 알림보내기
//    func sendNotification() {
//        let notificationContent = UNMutableNotificationContent()
//        let userDefaults = UserDefaults.standard
//        let userNotificationCenter = UNMutableNotificationContent()
//        let userNotificationCenter = UNUserNotificationCenter.current()
//
//        notificationContent.title = "\(userDefaults.name!)와 함께 걸어볼까요?"
//        notificationContent.body = "목표를 달성하고 \(userDefaults.name!)의 눈물을 멈춰주세요."
//
//        let notiTime = userDefaults.notiTime!
//        var date = DateComponents()
//        date.hour = notiTime.hour
//        date.minute = notiTime.minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let request = UNNotificationRequest(identifier: "dailyNoti", content: notificationContent, trigger: trigger)
//
//        notificationContent.add(request) { error in
//            if let error = error {
//                print("Notificaton Error: ", error)
//            }
//        }
//    }
//
//}
