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
//    let setGoalAlert: SetGoalAlertView? = UIView.loadFromNib()
//    let setResetTimeAlert: SetResetTimeAlertView? = UIView.loadFromNib()
//    let setNotificationAlertView: SetNotificationAlertView? = UIView.loadFromNib()
//    let setNotificationTimeAlertView: SetNotificationTimeAlertView? = UIView.loadFromNib()
//    @objc let setNameAlertView: SetNameAlertView? = UIView.loadFromNib()
    
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
        
      //  guard let textField = setNameAlertView?.userNameTextField else { return }
    //    textField.delegate = self
      //  NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: textField)
        userDefaults.stepsGoal = 1000
    } //: viewDidLoad
    
    func setUI() {
        print("Onboarding: ",#function)
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        firstAlertView.layer.borderColor = UIColor.white.cgColor
        firstAlertView.layer.borderWidth = 2
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
    
}
