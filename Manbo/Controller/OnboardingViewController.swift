//
//  OnboardingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - PROPERTIES
    static let identifier = "OnboardingViewController"
    @IBOutlet weak var welcomeLabel: UILabel!
    let goalAlert: GoalAlertView? = UIView.loadFromNib()

 
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "처음오셨군요!\n반가워요.\n목표 걸음 수를\n설정해 주세요!"
        print("화면전환된다.")
        
      
    } //: viewDidLoad
    

    @IBAction func alertView(_ sender: UIButton) {
        print("선택됨")
        self.view.addSubview(goalAlert ?? self.view)
    }

    // 메인 화면으로 전환하기
    @IBAction func okButtonClicked(_ sender: UIButton) {
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
    
}

