//
//  SetNotiPermissionViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/12/02.
//

import UIKit
// MARK: - (reset) -> "노티 yes/no " (-> 다음: noti/이름설정)
class SetNotiPermissionViewController: UIViewController {
    
    static let identifier = "SetNotiPermissionViewController"
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var notiLabel: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notiLabel.text = "알림을\n받으시겠어요?"
        backgroundView.customAlertSetting()
        
        
       
    }
    
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        openSetNameSB()
        
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        openNotiTimeSB()
       
        
    }
    func openSetNameSB() {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    func openNotiTimeSB() {
        let sb = UIStoryboard(name: "SetNotiTime", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNotiViewController.identifier) as? SetNotiViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
}
