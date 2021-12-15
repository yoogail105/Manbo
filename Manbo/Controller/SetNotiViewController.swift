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
    var isSendNoti = false {
        didSet {
            if !isOnboarding && isSendNoti {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
                
        }
    }
        
    let isOnboarding = !UserDefaults.standard.hasOnbarded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotiTimeLabel.text = "언제 알림을 드릴까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
        backgroundView.customAlertSetting()
        print(isSendNoti)
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
        //print("알림시간: ", userDefaults.notiTime!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("setNotiTiemVeiw", #function)
       
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOKButton = false // 유저디폴트에 저장하지 않는다. 없애는 것 아니고 그냥 취소하는거야
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOKButton = true // 유저디폴트값에 시간을 저장한다.
        self.userDefaults.notiTime = self.datePicker.date //중복저장되는것같은데..
        //일단 저장되어있던 알림을 지운다.
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
    
        //알림을 새로 등록한다.
        
        if isOnboarding {
            requestNotificationAuthorization()
            openSetNameSB()
            return
        } else {
            checkNotificationAuthorization()
        }
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
                self.sendNotification()
                
            default :
                // 허락한게 아니라면 얼럿 띄워서 허락 요청하기
                print(settings.authorizationStatus)
                DispatchQueue.main.async {
                    self.notificaitonSettingAlert()
                    print("noti 띄우기")
                }
            }
        }
    }
    
    // 온보딩: 권한 요청 -> 유저가 허락했는지 안했는지 확인할 수 있다: success
    func requestNotificationAuthorization() {
        
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        // success는 Bool형.
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("requestNotificationAuthorization Error: \(error)")
            } else if success {
                print("success: requestNotificationAuthorization success", success)
                self.sendNotification()
            } else {
                print("!success: requestNotificationAuthorization success", success)
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
    
    
    // 알림보내기: 알림 내용을 세팅해주기
    func sendNotification() {
        print("sendNoti")
       
        self.isSendNoti = true
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
