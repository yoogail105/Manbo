//
//  SetNameViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit
// MARK: - (노티예스) -> "노티 시간 설정" (-> 다음: 이름설정)
class SetNotiViewController: UIViewController {
    static let identifier = "SetNotiViewController"
    let userDefaults = UserDefaults()
    
    @IBOutlet weak var cancelButton: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var setNotiTimeLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var isOKButton = true
    let isOnboarding = !UserDefaults.standard.hasOnbarded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotiTimeLabel.text = "언제 알림을 드릴까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
        backgroundView.customAlertSetting()
        
        if isOnboarding {
            okButton.setTitle("다음", for: .normal)
            cancelButton.isHidden = true
            
        } else {
            cancelButton.isHidden = false
            
        }
        
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
        userDefaults.notiTime = datePicker.date
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
        requestNotificationAuthorization()
        
        if isOnboarding {
            
            openSetNameSB()
        } else {
            
            dismiss(animated: true, completion: nil)
        }
        
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
    
    func openSetNameSB() {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    // 알림보내기
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        let userName = userDefaults.name ?? "만보"
        notificationContent.title = "\(userName)님이 보낸 메세지:"
        let notiTime = userDefaults.notiTime!
        notificationContent.body = "산책 언제 가요? 산책 가요!"
        
        
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
