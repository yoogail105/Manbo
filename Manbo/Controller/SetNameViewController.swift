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
    
    var maxLength = 8
    var notiText = "2글자 이상 8글자 이하로 입력해주세요"
    var isCoreectedName = false
    var longName = false
    let userDefaults = UserDefaults.standard
    var isOK = false
    // MARK: - VIEWDIDROW
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let textField = self.userNameTextField else { return }
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: textField)
        
        backgroundView.customAlertSetting()
        completeButton.activeButtonColor(isActive: isCoreectedName)
        completeButton.isEnabled = false
        
        if !isCoreectedName {
            self.notiBanenr(notiText: notiText)
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
                    isCoreectedName = true
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                    notiText = "8글자를 넘어갈 수 없어요!"
                    isCoreectedName = true
                }
                
                else if text.count < 2 {
                    longName = false
                    notiText = "2글자 이상 8글자 이하로 입력해주세요"
                    isCoreectedName = false
                }
                else if text == "만보" {
                    longName = false
                    notiText = "다른 이름을 지어주세요!"
                    isCoreectedName = false
                }
                else {
                    longName = false
                    isCoreectedName = true
                    view.setNeedsDisplay()
                }
                completeButton.isEnabled = isCoreectedName
                completeButton.activeButtonColor(isActive: isCoreectedName)

            }
        }
    }
    
    @IBAction func completeButtonClicked(_ sender: UIButton) {
        isOK = true
        let changedName = userNameTextField.text!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeNameNotificaiton"), object: nil, userInfo: ["newName": changedName])
                                            
        self.dismiss(animated: true, completion: nil)
                                        
                   
        
    }
  
    @IBAction func cancelButton(_ sender: UIButton) {
        isOK = false
        dismiss(animated: true, completion: nil)
    }
    
    func notiBanenr(notiText: String) {
        let banner = NotificationBanner(title: notiText, subtitle: "", leftView: nil, rightView: nil, style: .info, colors: nil)
        
        banner.show()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            banner.dismiss()
//        })
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
    
    func incorrectNameNotification(){
        
        if self.longName {
            self.notiBanenr(notiText: self.notiText)
        } else if !self.isCoreectedName {
            self.notiBanenr(notiText: self.notiText)
        }
    }
    
}

