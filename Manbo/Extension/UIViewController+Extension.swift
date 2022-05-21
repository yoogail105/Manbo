//
//  UIViewController+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/21.
//

import UIKit
extension UIViewController {

    func setUserImage(userPercent: Double) -> String {
        var userImage = Manbo.manbo100
        switch userPercent {
        case 0.0 ..< 0.3:
            userImage = Manbo.manbo00
        case 0.3 ..< 0.5:
            userImage = Manbo.manbo01
        case 0.5 ..< 0.8:
            userImage = Manbo.manbo02
        case 0.8 ..< 1.0:
            userImage = Manbo.manbo03
        default:
            userImage = Manbo.manbo100
        }
        
        return userImage.rawValue
    }
    
    func showToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
    
    func makeAlertWithoutCancel(message: String, okTitle: String, okAction: ((UIAlertAction) -> Void)?) {
   
        self.view.tintColor = UIColor.appColor(.mainGreen)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        okAction.greenAlertText()
        alert.addAction(okAction)

        self.present(alert, animated: true)
    }
    
    func makeToastAndPop(message: String) {
      let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      self.present(alert, animated: true)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        self.dismiss(animated: true) {
          self.navigationController?.popViewController(animated: true)
        }
      })
    }

}



extension UIAlertAction {
    
    func greenAlertText() {
        self.setValue(UIColor.appColor(.mainGreen), forKey: "titleTextColor")
    }
    
    func redAlertText() {
        self.setValue(UIColor.red, forKey: "titleTextColor")
    }
}
