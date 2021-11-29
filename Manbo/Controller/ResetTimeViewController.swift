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
        backgroundView.customAlertSetting()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isOK {
            userDefaults.resetTime = self.datePicker.date
        }
        print("리셋타임은 \(userDefaults.notiTime!)")
    }
    

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOK = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeResteTimeNotification"), object: ["newStep": userDefaults.currentStepCount!])
                                            
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOK = true
        dismiss(animated: true, completion: nil)
    }
   
}
