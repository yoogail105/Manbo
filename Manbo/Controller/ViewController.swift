//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit
import SideMenu

class ViewController: UIViewController {
    
    // MARK: - PROPERTIES
    static let identifier = "ViewController"
 
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    
  
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUI()

       
    }//: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.isNavigationBarHidden = true
    }

    // calendar에서는 보이도록
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
//        goalLabel.text = NSLocalizedString("goal_steps", comment: "목표 걸음 수")
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) 10,000"
        
    }
    
  

    @IBAction func settingButtonClicked(_ sender: UIButton) {
        print("setting선택")
    
        guard let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: SettingViewController.identifier) as? SideMenuNavigationController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    //다른 뷰에서는 탭바 내려가도록한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
}


