//
//  TabViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit

class TabViewController: UIViewController {

    static let identifier = "TabViewController"
    @IBOutlet weak var tabBarBackgroundView: UIView!
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    var vcList = [UIViewController]()
   
    
    @IBOutlet var tabView:UIView!
    @IBOutlet var buttons:[UIButton]!

    
    // VC연결
    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.identifier)
    //camera = 1 buttons[1]
    let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraViewController.identifier)
    let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarNC")
    
    //camera
    let imagePickerController = UIImagePickerController()
    
  
  // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        
        // VC배열에 넣기
        vcList = [mainVC, cameraVC, calendarVC]
        
        setButtonTag()
        
        // 메인 뷰 불러오기
        buttons[selectedIndex].isSelected = true
        tabChanged(sender: buttons[selectedIndex])
        
        imagePickerController.delegate = self
        buttons[1].addTarget(self, action: #selector(cameraOpen), for: .touchUpInside)
        
    }

    
    func setButtonTag() {
        for (index, button) in buttons.enumerated() {
            button.tag = index
        }
    }
    
    @objc func cameraOpen() {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController,animated: true, completion:  nil)

    }
    
    
//    @IBAction func heartButtonClicked(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Chat", bundle: nil)
//        guard let vc = sb.instantiateViewController(withIdentifier: ChatViewController.identifier) as? ChatViewController else { return }
//        present(vc, animated: true, completion: nil)
//    }
    
} //:viewDidLoad



// MARK: - Actions
extension TabViewController {
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = vcList[previousIndex]
        
        //기존의 뷰 제거
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = vcList[selectedIndex]
        
        // 최상단 프레임에
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(tabView)
    }
    
   
}

extension TabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
