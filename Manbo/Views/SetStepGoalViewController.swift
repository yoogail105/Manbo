//
//  SetStepGoalViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class SetStepGoalViewController: UIViewController {
    
    static let identifier = "SetStepGoalViewController"
    
    @IBOutlet weak var setGoalBackgroundView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var stepsGoalList: [Int] = []
    var newGoal = 3000
    var isOK = false
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        stepsGoalList.append(contentsOf: stride(from: 3000, to: 21000, by: 1000))
        titleLabel.text = "하루 목표 걸음을\n설정해 주세요!"
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if isOK {
            userDefaults.stepsGoal = newGoal
        }
        print("목표걸음수는 \(userDefaults.stepsGoal!)")
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        isOK = true
        userDefaults.stepsGoal = newGoal
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeGoalNotification"), object: nil, userInfo: ["myValue": newGoal])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        isOK = false
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension SetStepGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

        self.newGoal = stepsGoalList[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? { return NSAttributedString(string: String(self.stepsGoalList[row]), attributes: [.foregroundColor:UIColor.white]) }
}


