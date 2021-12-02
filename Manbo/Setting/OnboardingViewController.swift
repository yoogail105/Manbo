//
//  OnboardingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//


// AlertView 스토리보드&VC로 옮기기..!!
import UIKit
import NotificationBannerSwift
import UserNotifications

class OnboardingViewController: UIViewController {
    
    // MARK: - PROPERTIES
    static let identifier = "OnboardingViewController"
    
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var firstAlertView: UIView!
    @IBOutlet weak var tabBarBackgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    
    // AlertView
    let setGoalAlert: SetGoalAlertView? = UIView.loadFromNib()
    let setResetTimeAlert: SetResetTimeAlertView? = UIView.loadFromNib()
    let setNotificationAlertView: SetNotificationAlertView? = UIView.loadFromNib()
    let setNotificationTimeAlertView: SetNotificationTimeAlertView? = UIView.loadFromNib()
    @objc let setNameAlertView: SetNameAlertView? = UIView.loadFromNib()
    
    // pickerView
    var stepsGoalList: [Int] = []
    var typeValue = String()
    
    // checkName -> setNameVC
    var maxLength = 8
    var notiText = "2글자 이상 8글자 이하로 입력해주세요"
    var isCoreectedName = false
    var longName = false
    let userDefaults = UserDefaults.standard
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Onboarding: ",#function)
        setUI()
        stepsGoalList.append(contentsOf: stride(from: 1000, to: 30000, by: 1000))
        welcomeLabel.text = "처음오셨군요!\n반가워요.\n같이 걸어 볼까요?"
        
        guard let textField = setNameAlertView?.userNameTextField else { return }
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: textField)
        userDefaults.stepsGoal = 1000
    } //: viewDidLoad
    
    func setUI() {
        print("Onboarding: ",#function)
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        firstAlertView.layer.borderColor = UIColor.white.cgColor
        firstAlertView.layer.borderWidth = 2
    }
    
    
    //setNameVC
    @objc private func textDidChange(_ notification: Notification) {
        //print("Onboarding: ",#function)
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > maxLength {
                    longName = true
                    //  8글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                    notiText = "8글자를 넘어갈 수 없어요!"
                    isCoreectedName = true
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                    notiText = "8글자를 넘어갈 수 없어요!"
                    isCoreectedName = true
                    
                }
                
                else if text.count < 2 {
                    longName = false
                    notiText = "2글자 이상 8글자 이하로 입력해주세요"
                    // active상태에 따라서 버튼 바꾸어주고 싶은데 안된다.. 오잉...갑자기되었다..?
                    
                    isCoreectedName = false
                    
                    //
                }
                else if text == "만보" {
                    
                    longName = false
                    notiText = "다른 이름을 지어주세요!"
                    isCoreectedName = false
                    
                }
                else {
                    longName = false
                    isCoreectedName = true
                    setNameAlertView?.setNeedsDisplay()
                    
                }
                setNameAlertView?.completeButton.isEnabled = isCoreectedName
                setNameAlertView?.completeButton.activeButtonColor(isActive: isCoreectedName)
                
                
            }
            
        }
    }
    
    // MARK: - SetGoal 먼가..코드 정리하기..
    //"같이 걸어요 선택했을 때: 목표걸음 수 설정
    @IBAction func alertView(_ sender: UIButton) {

        let sb = UIStoryboard(name: "SetStepGoal", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetStepGoalViewController.identifier) as? SetStepGoalViewController else {
            print("Error")
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
     
        present(vc, animated: true, completion: nil)
    
        }
    
    
    // MARK: - SetResetTimeAlertView: 리셋타임
    @objc func toSetResetButtonClicked() {
        print("클릭됨.")
        let alert = setResetTimeAlert
        self.view.addSubview(setResetTimeAlert ?? self.view)
        setGoalAlert?.removeFromSuperview()
        alert?.datePicker.setValue(UIColor.white, forKey: "textColor")
        alert?.resetTimeLabel.text = "언제 걸음을\n새로 측정할까요?"
        alert?.backgroundView.customAlertSetting()
        
        
        alert?.toSetNotificationButton.addTarget(self, action: #selector(toSetNotificationButtonClicked), for: .touchUpInside)
        
    }
    
    // MARK: - SetNotification Yes/No
    @objc func toSetNotificationButtonClicked() {
        UserDefaults.standard.resetTime = setResetTimeAlert?.datePicker.date
        
        
        print("reestTiem: \(UserDefaults.standard.resetTime!)")
        
        
        let alert = setNotificationAlertView
        self.view.addSubview(setNotificationAlertView ?? self.view)
        setResetTimeAlert?.removeFromSuperview()
        
        alert?.setNotiLabel.text = "알림을\n받으시겠어요?"
        alert?.backgroundView.customAlertSetting()
        alert?.yesNotiButton.addTarget(self, action: #selector(toSetNotificaitonTimeButtonClicked), for: .touchUpInside)
        alert?.noNotiButton.addTarget(self, action: #selector(toSetNameButtonClicked), for: .touchUpInside)
        
    }
    
    // MARK: - SetNotiTime
    @objc func toSetNotificaitonTimeButtonClicked() {
        presentAlert(alertFrom: self.setNotificationAlertView!, alertTo: self.setNotificationTimeAlertView!)
        let alert = setNotificationTimeAlertView
        alert?.backgroundView.customAlertSetting()
        alert?.setNotiTimeLabel.text = "언제 알림을 드릴까요?"
        alert?.datePicker.setValue(UIColor.white, forKey: "textColor")
        
        
        // alert?.datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        alert?.toSetNameButton.addTarget(self, action: #selector(toSetNameButtonClicked), for: .touchUpInside)
        
    }
    
    func changed(_ sender: UIDatePicker) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        
        let date = dateformatter.string(from: sender.date)
        return date
        
    }
    
    func presentAlert(alertFrom: UIView, alertTo: UIView) {
        self.view.addSubview(alertTo)
        alertFrom.removeFromSuperview()
    }
    
    // MARK: - SetNameAlert
    @objc func toSetNameButtonClicked() {
        UserDefaults.standard.notiTime = setNotificationTimeAlertView?.datePicker.date
        presentAlert(alertFrom: self.setNotificationAlertView!, alertTo: self.setNameAlertView!)
        
        let alert = setNameAlertView
        alert?.backgroundView.customAlertSetting()
        alert?.completeButton.activeButtonColor(isActive: isCoreectedName)
        alert?.completeButton.isEnabled = false
        
        if !isCoreectedName {
            notiBanenr(notiText: notiText)
        }
        
        alert?.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
    }
    
    // 메인 화면으로 전환하기
    @objc func completeButtonClicked() {
        // checkCorrectUserName()
        UserDefaults.standard.name = setNameAlertView?.userNameTextField.text
        print(UserDefaults.standard.string(forKey: "name") ?? "no name")
        setNameAlertView?.removeFromSuperview()
        let storyboard = UIStoryboard(name: "TabView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: TabViewController.identifier) as? TabViewController else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        
        // 첫 런치 + 초기 정보를 저장한 후에 Onboarding 값 바꾸어주기
        UserDefaults.standard.firstLaunchDate = Date()
        UserDefaults.standard.hasOnbarded = true
        present(controller, animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func notiBanenr(notiText: String) {
        let banner = NotificationBanner(title: notiText, subtitle: "", leftView: nil, rightView: nil, style: .info, colors: nil)
        
        banner.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            banner.dismiss()
        })
    }
}


extension OnboardingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stepsGoalList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(stepsGoalList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.stepsGoal = stepsGoalList[row]
        print("목표걸음수는 \(UserDefaults.standard.stepsGoal!)")
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? { return NSAttributedString(string: String(self.stepsGoalList[row]), attributes: [.foregroundColor:UIColor.white]) }
}


extension OnboardingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        incorrectNameNotification()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        incorrectNameNotification()
        return true
    }
    
    func incorrectNameNotification(){
        
        if self.longName {
            self.notiBanenr(notiText: notiText)
        } else if !self.isCoreectedName {
            self.notiBanenr(notiText: self.notiText)
        }
    }
    
}

