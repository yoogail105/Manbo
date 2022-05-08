//
//  ResetTimeViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class ResetTimeViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    static let identifier = "ResetTimeViewController"
    
    @IBOutlet weak var resetTimeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    let userDefaults = UserDefaults.standard
    var isOK = false
    let isOnboarding = !UserDefaults.standard.hasOnboarded
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetTimeLabel.text = "언제 걸음을\n새로 측정할까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
        backgroundView.customAlertSetting()
        if isOnboarding {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
        
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if isOK {
//            userDefaults.resetTime = self.datePicker.date
//        }
//        print("리셋타임은 \(userDefaults.notiTime!)")
//    }
    

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOK = false

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOK = true
        
        userDefaults.resetTime = self.datePicker.date
    //    print("리셋타임은 \(userDefaults.notiTime!)")
        
        
        if isOnboarding {
            // 온보딩이라면
            openSetNotiPermission()
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeResetTimeNotification"), object: nil, userInfo: ["newStep": userDefaults.currentStepCount!])
        dismiss(animated: true, completion: nil)
        }
    }
    
    func openSetNotiPermission() {
        let sb = UIStoryboard(name: "SetNotiSetNotiPermission", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNotiPermissionViewController.identifier) as? SetNotiPermissionViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
}
