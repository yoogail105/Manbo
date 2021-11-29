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
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var resetTimeLabel: UILabel!
    @IBOutlet weak var notiTimeLabel: UILabel!
    
    
    let setMenuItem = ["공지사항", "문의하기", "이용양관", "개인정보정책", "오픈소스", "버전"]
    
    let onboardingVC = OnboardingViewController()
    let setNameAlertView: SetNameAlertView? = UIView.loadFromNib()
    let setResetTimeAlert: SetResetTimeAlertView? = UIView.loadFromNib()
    let setNotificationTimeAlertView: SetNotificationTimeAlertView? = UIView.loadFromNib()
    let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNameLabelUI()
        notiTimeLabel.setTimeLabelUI()
        resetTimeLabel.setTimeLabelUI()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userNameLabel.text = userDefaults.name!
        resetTimeLabel.text = dateFormatter.simpleTimeString(date: userDefaults.resetTime!)
        notiTimeLabel.text =  dateFormatter.simpleTimeString(date: userDefaults.notiTime!)
    }
    
    func setResetButtonsUI() {
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
        
        present(vc, animated: true, completion: nil
        )
    }
     
    
    @IBAction func resetTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil
        )
        
    }
    
    @IBAction func resetNotiTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil
        )
    }
    
    func setNameLabelUI() {
        resetNameButton.setTitle(userDefaults.name, for: .normal)
        resetNameButton.setTitleColor(UIColor.white, for: .normal)
        resetNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)

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
        let vc = SettingTextViewController()
        present(vc, animated: true, completion: nil)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
