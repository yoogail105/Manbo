//
//  OnboardingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - PROPERTIES
    
    @IBOutlet weak var welcomeLabel: UILabel!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "처음오셨군요!\n반가워요.\n목표 걸음 수를\n설정해 주세요!"
      
      
    } //: viewDidLoad
    
    // 메인 화면으로 전환하기
    @IBAction func okButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: TabViewController.identifier) as? TabViewController else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        
        present(controller, animated: true, completion: nil)
    }
    
}

