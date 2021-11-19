//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit

class ViewController: UIViewController {
    
    static let identifier = "ViewController"
 
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    
    @IBOutlet weak var tabBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        designableTabBar()

       
    }//: VIEWDIDLOAD

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])

        goalLabel.text = LocalizableStrings.goal_steps.localized
        
    }
    
  
    func designableTabBar() {
        tabBarView.cornerRounded(cornerRadius: tabBarView.frame.size.height / 2)
    }
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        
        guard let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: SettingViewController.identifier) as? SettingViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func mainButtonCilicked(_ sender: UIButton) {
    }
    @IBAction func calendarButtonClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func tabBarClicked(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        
    }
    
        //다른 뷰에서는 탭바 내려가도록한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
}


