//
//  SettingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    // Button
    @IBOutlet weak var resetNameButton: UIButton!
    @IBOutlet weak var resetGoalButton: UIButton!
    @IBOutlet weak var resetStepTimeButton: UIButton!
    @IBOutlet weak var resetNotiTimeButton: UIButton!
    @IBOutlet weak var resetColorButton: UIButton!
    
    
    @IBOutlet weak var stepGoalLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var resetTimeLabel: UILabel!
    @IBOutlet weak var notiTimeLabel: UILabel!
    
    
    let setMenuItem = ["공지사항", "문의하기", "개인정보정책", "버전"]
    
    let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        
        setButtonsUI()
        
        
        notiTimeLabel.setTimeLabelUI()
        resetTimeLabel.setTimeLabelUI()
        stepGoalLabel.setTimeLabelUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SettingViewController", #function)
        
        print(userDefaults.name!, String(userDefaults.stepsGoal!), dateFormatter.simpleTimeString(date: userDefaults.resetTime!), dateFormatter.simpleTimeString(date: userDefaults.notiTime!))
        
        userNameLabel.text = userDefaults.name!
        stepGoalLabel.text = String(userDefaults.stepsGoal!)
        resetTimeLabel.text = dateFormatter.simpleTimeString(date: userDefaults.resetTime!)
        notiTimeLabel.text =  dateFormatter.simpleTimeString(date: userDefaults.notiTime!)
        view.layoutIfNeeded()
    }
    
    func setButtonsUI() {
        resetNameButton.settingButtonUI()
        resetGoalButton.settingButtonUI()
        resetNotiTimeButton.settingButtonUI()
        resetStepTimeButton.settingButtonUI()
        resetColorButton.settingButtonUI()
    }
    
    
    
    
    @IBAction func resetNameButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func setpGoalButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetStepGoal", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetStepGoalViewController.identifier) as? SetStepGoalViewController else {
            print("Error")
            return
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func resetTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetResetTime", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: ResetTimeViewController.identifier) as? ResetTimeViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func resetNotiTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetNotiTime", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNotiViewController.identifier) as? SetNotiViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}//: ViewDidLoad


// MARK: - TABLEVIEW
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setMenuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingBasicTableViewCell.identifier, for: indexPath) as? SettingBasicTableViewCell else {
            return UITableViewCell() }
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.menuLable.text = setMenuItem[row]
        
        
        if setMenuItem[row] == "버전" {
            cell.rightLabel.text = "1.0.0."
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 공지사항은 다른 테이블뷰로 이동
        // 이용약관, 개인보호정책, 오픈소스, 버전은 문자열 표시
        let cellURL = ["https://hmhhsh.notion.site/ab8d1336219d4a36a3b0b43adaa603b3",
                       "https://hmhhsh.notion.site/f2f120f85fdf4bfcb9e52db44ef7b6f1",
                       "https://hmhhsh.notion.site/19e03d2d23c248978f0f664c60f333bb"]
        
        let row = indexPath.row
        
        if setMenuItem[row] != "버전" {
            let sb = UIStoryboard(name: "SettingText", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: SettingTextViewController.identifier) as? SettingTextViewController else { return }
            vc.urlString = cellURL[row]
            present(vc, animated: true, completion: nil)
        }
    }
    
    
}

