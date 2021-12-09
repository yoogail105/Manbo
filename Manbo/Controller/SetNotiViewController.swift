//
//  SetNameViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit
import UserNotifications
import FirebaseCrashlytics

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
    var isnotiAuthorization = true
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(turnOffNotification), name: .offNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("setNotiTiemVeiw", #function)
        
        if isOKButton {
            userDefaults.notiTime = datePicker.date
        }
        print("알림시간: ", userDefaults.notiTime!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("setNotiTiemVeiw", #function)
       
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOKButton = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOKButton = true
        self.userDefaults.notiTime = self.datePicker.date
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
    
        
        if isOnboarding {
            requestNotificationAuthorization()
            openSetNameSB()
        } else {
            checkNotificationAuthorization()
            if !isnotiAuthorization {
                DispatchQueue.main.async {

                    self.notificaitonSettingAlert()
                }
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func turnOffNotification() {
        userDefaults.removeObject(forKey: "notiTime")
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
        guard let noti = userDefaults.notiTime else {
            print("notitiem없음")
            return
        }
        print(noti)
    }
    
    // MARK: - NOTIFICATION CENTER
    
    func checkNotificationAuthorization() {
        userNotificationCenter.getNotificationSettings { (settings) in
            print("Checking notification status")

            switch settings.authorizationStatus {
            case .authorized:
                print("authorized")
                self.requestNotificationAuthorization()
               
            default :
                print(settings.authorizationStatus)
                DispatchQueue.main.async {
                    self.notificaitonSettingAlert()
                    print("noti띄우기")
                }
            }
        }
        
    }
    
    // 권한 요청 -> 권한 요청 팝업
    func requestNotificationAuthorization() {
      //  let userNotificationCenter = UNUserNotificationCenter.current()
        
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("requestNotificationAuthorization Error: \(error)")
            } else {
                print("requestNotificationAuthorization success")
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
        let notiTime = userDefaults.notiTime ?? Date()
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
        if !isOnboarding{
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
        }
        }
    }
    
    func notificaitonSettingAlert() {
        
            self.showAlert(title: "알림을 사용할 수 없습니다.", message: "여러분이 원하는 시간에 알림을 보낼 수 있도록 '설정 > 만보랑'에서 알림 서비스를 켜주세요.", okTitle: "허용하기") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url) { success in
                    }
                }
                
            }
        
    }
}
