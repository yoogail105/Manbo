//
//  SetNameViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class SetNotiViewController: UIViewController {
    static let identifier = "SetNotiViewController"
    let userDefaults = UserDefaults()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var setNotiTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isOKButton = true
    override func viewDidLoad() {
        super.viewDidLoad()

        setNotiTimeLabel.text = "언제 알림을 드릴까요?"
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isOKButton {
            userDefaults.notiTime = datePicker.date
        }
        print("알림시간: ", userDefaults.notiTime!)
    }
    

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOKButton = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOKButton = true
        dismiss(animated: true, completion: nil)
    }
}
