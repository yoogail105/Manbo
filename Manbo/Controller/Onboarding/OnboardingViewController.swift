//
//  OnboardingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - PROPERTIES
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var firstAlertView: UIView!
    @IBOutlet weak var tabBarBackgroundView: UIView!
    static let identifier = "OnboardingViewController"
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    // AlertView
    let setGoalAlert: SetGoalAlertView? = UIView.loadFromNib()
    let setResetTimeAlert: SetResetTimeAlertView? = UIView.loadFromNib()
    let setNotificationAlertView: SetNotificationAlertView? = UIView.loadFromNib()
    let setNotificationTimeAlertView: SetNotificationTimeAlertView? = UIView.loadFromNib()
    let setNameAlertView: SetNameAlertView? = UIView.loadFromNib()

    
    var stepsGoalList: [Int] = []
    var typeValue = String()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        stepsGoalList.append(contentsOf: stride(from: 3000, to: 21000, by: 1000))
        welcomeLabel.text = "처음오셨군요!\n반가워요.\n같이 걸어 볼까요?"
        print("화면전환된다.")
        setGoalAlert?.pickerView.delegate = self
        setGoalAlert?.pickerView.dataSource = self
    
      
    } //: viewDidLoad
    
    func setUI() {
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        firstAlertView.layer.borderColor = UIColor.white.cgColor
        firstAlertView.layer.borderWidth = 2
    }
    
    // MARK: - SetGoal 먼가..코드 정리하기..
    @IBAction func alertView(_ sender: UIButton) {
        let alert = setGoalAlert
        alert?.setGoalBackgroundView.customAlertSetting()
        alert?.setGoalLabel.text = "하루 목표 걸음을 설정해 주세요!"
        self.view.addSubview(setGoalAlert ?? self.view)
        
        alert?.toSetResetButton.addTarget(self, action: #selector(toSetResetButtonClicked), for: .touchUpInside)
        
    }
    
    // MARK: - SetResetTimeAlertView
    @objc func toSetResetButtonClicked() {
        print("클릭됨.")
        
        let alert = setResetTimeAlert
        self.view.addSubview(setResetTimeAlert ?? self.view)
        setGoalAlert?.removeFromSuperview()
        
        alert?.resetTimeLabel.text = "측정 기준 시간을\n 설정해 주세요!"
        alert?.backgroundView.customAlertSetting()
    
        alert?.toSetNotificationButton.addTarget(self, action: #selector(toSetNotificationButtonClicked), for: .touchUpInside)
        
    }
    
    // MARK: - SetNotification Yes/No
    @objc func toSetNotificationButtonClicked() {
        UserDefaults.standard.resetTime = changed(setResetTimeAlert!.datePicker)
        print("reestTiem: \(UserDefaults.standard.resetTime!)")
        

        let alert = setNotificationAlertView
        self.view.addSubview(setNotificationAlertView ?? self.view)
        setResetTimeAlert?.removeFromSuperview()
        
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
        
        
       // alert?.datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    
        alert?.toSetNameButton.addTarget(self, action: #selector(toSetNameButtonClicked), for: .touchUpInside)

    }
    
    func changed(_ sender: UIDatePicker) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        
        let date = dateformatter.string(from: sender.date)
        return date
    
    }
    
    func presentAlert(alertFrom: UIView, alertTo: UIView) {
        self.view.addSubview(alertTo)
        alertFrom.removeFromSuperview()
    }
    
    // MARK: - SetName
    @objc func toSetNameButtonClicked() {
        UserDefaults.standard.notiTime = changed(setNotificationTimeAlertView!.datePicker)
        print("notiTime: \(UserDefaults.standard.notiTime ?? "알람거부")")
        
        presentAlert(alertFrom: self.setNotificationAlertView!, alertTo: self.setNameAlertView!)
        let alert = setNameAlertView
        
        alert?.backgroundView.customAlertSetting()
        
        
        alert?.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
    }
    
    // 메인 화면으로 전환하기
    @objc func completeButtonClicked() {
        UserDefaults.standard.name = setNameAlertView?.userNameLabel.text
        print(UserDefaults.standard.string(forKey: "name") ?? "no name")
        setNameAlertView?.removeFromSuperview()
        let storyboard = UIStoryboard(name: "TabView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: TabViewController.identifier) as? TabViewController else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        
        // 첫 런치 + 초기 정보를 저장한 후에 Onboarding 값 바꾸어주기
       // UserDefaults.standard.hasOnbarded = true
        present(controller, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
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
}
