//
//  AppDelegate.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .black
        
        IQKeyboardManager.shared.enable = true
        
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            // Use this configuration when opening realms
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        
        // 새로운 설정을 기본 저장소에 적용
        Realm.Configuration.defaultConfiguration = config
        
        // firebase 초기화
        FirebaseApp.configure()
        
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if error != nil {
            } else if token != nil {
          }
        }
        
        NetworkMonitor.shared.startMonitoring()

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // 업데이트 필요하면 true, 최신버전이면 false
    func isUpdateAvailable() -> Bool {
        guard let version = Bundle.main.infoDictionary? ["CFBundleShortVersionString"] as? String,
              let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(Bundle.main.AppStoreID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              results.count > 0,
              let appStoreVersion = results[0]["version"] as? String
        else { print("return")
            return false }
        print("version: \(version), appStoreVersion = \(appStoreVersion)")
        if !(version == appStoreVersion) { return true }
        else{ return false }
        return false
    }
    
}

// MARK: - USER NOTIFICATION: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Firebase 토큰과 애플의 토큰 매칭
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    // didReceive: push 클릭 했을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    // 포그라운드 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
        completionHandler([.list, .banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
            
    }
    
    
    
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
     
    }

   
}
