//
//  SetNameViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit
import NotificationBannerSwift

class SetNameViewController: UIViewController {
    
    static let identifier = "SetNameViewController"
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    var maxLength = 8
    var notiText = "2글자 이상 8글자 이하로 입력해주세요"
    var isCorrectedName = false
    var longName = false
    let userDefaults = UserDefaults.standard
    var isOK = false
    let isOnboarding = !UserDefaults.standard.hasOnboarded
    
    // MARK: - VIEWDIDROW
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let textField = self.userNameTextField else { return }
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: textField)
    
        
       
        backgroundView.customAlertSetting()
        completeButton.activeButtonColor(isActive: isCorrectedName)
        completeButton.isEnabled = false

        if isOnboarding {
            cancelButton.isHidden = true
            okButton.setTitle("같이 걸어요!", for: .normal)
        } else {
            cancelButton.isHidden = false
            userNameTextField.text = userDefaults.name!
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if isOK {
            userDefaults.name = userNameTextField.text
        }
    }

    

    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > maxLength {
                    longName = true
                    //  8글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                    notiText = "8글자를 넘어갈 수 없어요!"
                    isCorrectedName = true
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                    notiText = "8글자를 넘어갈 수 없어요!"
                    isCorrectedName = true
                }
                
                else if text.count < 2 {
                    longName = false
                    notiText = "2글자 이상 8글자 이하로 입력해주세요"
                    isCorrectedName = false
                }
             
                else {
                    longName = false
                    isCorrectedName = true
                    view.setNeedsDisplay()
                }
                
                completeButton.isEnabled = isCorrectedName
                completeButton.activeButtonColor(isActive: isCorrectedName)

            }
        }
    }
    
    @IBAction func completeButtonClicked(_ sender: UIButton) {
        isOK = true
        
        let changeName = userNameTextField.text!
        userDefaults.name = changeName
        self.view.endEditing(true)
        
         if isOnboarding {
             UserDefaults.standard.firstLaunchDate = Date()
             UserDefaults.standard.hasOnboarded = true
             openTabViewSB()
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeNameNotification"), object: nil, userInfo: ["newName": changeName])
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func openTabViewSB() {
        
        let sb = UIStoryboard(name: "TabView", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: TabViewController.identifier) as? TabViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
  
    @IBAction func cancelButton(_ sender: UIButton) {
        isOK = false
        dismiss(animated: true, completion: nil)
    }
    
    func notiBanner(notiText: String) {
        let banner = NotificationBanner(title: notiText, subtitle: "", leftView: nil, rightView: nil, style: .info, colors: nil)

        banner.show()
        
        // notiBanner 지속시간
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            banner.dismiss()
        })
    }
    
}

extension SetNameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if !isCorrectedName {
            DispatchQueue.main.async {
                print("incorrectedName")
                self.notiBanner(notiText: self.notiText)
            }
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        incorrectNameNotification()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        incorrectNameNotification()
        return true
    }
    
    func incorrectNameNotification() {

        if self.longName {
            self.notiBanner(notiText: self.notiText)
        } else if !self.isCorrectedName {
            self.notiBanner(notiText: self.notiText)
        }
    }
    
}

