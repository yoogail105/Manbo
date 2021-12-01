//
//  ResetTimeViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class ResetTimeViewController: UIViewController {
    static let identifier = "ResetTimeViewController"
    
    @IBOutlet weak var resetTimeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    let userDefaults = UserDefaults.standard
    var isOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetTimeLabel.text = "언제 걸음을\n새로 측정할까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
        backgroundView.customAlertSetting()
    
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
        print("리셋타임은 \(userDefaults.notiTime!)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeResteTimeNotification"), object: nil, userInfo: ["newStep": userDefaults.currentStepCount!])
        dismiss(animated: true, completion: nil)
    }
   
}
