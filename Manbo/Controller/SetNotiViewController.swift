//
//  SetNameViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class SetNotiViewController: UIViewController {
    static let identifier = "SetNotiViewController"
    let userDefaults = UserDefaults()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var setNotiTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var isOKButton = true
    override func viewDidLoad() {
        super.viewDidLoad()

        setNotiTimeLabel.text = "언제 알림을 드릴까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isOKButton {
            userDefaults.notiTime = datePicker.date
        }
        print("알림시간: ", userDefaults.notiTime!)
    }
    

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOKButton = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOKButton = true
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
        requestNotificationAuthorization()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NOTIFICATION CENTER
    // 권한 요청 -> 권한 요청 팝업
    func requestNotificationAuthorization() {
        let userNotificationCenter = UNUserNotificationCenter.current()

        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if success {
                self.sendNotification()
            }
        }
    }

    // 알림보내기
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "\(userDefaults.name!)님이 메세지를 보냈습니다."
        notificationContent.body = "오늘도 저를 보러 와주실 거죠?"

        let notiTime = userDefaults.notiTime!
        var date = DateComponents()
        date.hour = notiTime.hour
        date.minute = notiTime.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNoti", content: notificationContent, trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notificaton Error: ", error)
            }
        }
    }
}
