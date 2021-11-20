//
//  TabViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit

class TabViewController: UIViewController {

  
    @IBOutlet weak var tabBarBackgroundView: UIView!
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    var vcList = [UIViewController]()
    
    @IBOutlet var tabView:UIView!
    @IBOutlet var buttons:[UIButton]!

    
    // VC연결
    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.identifier)
    let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraViewController.identifier)
    let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.identifier)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        
        // VC배열에 넣기
        vcList = [mainVC, cameraVC, calendarVC]
        
        setButtonTag()
        
        // 메인 뷰 불러오기
        buttons[selectedIndex].isSelected = true
        tabChanged(sender: buttons[selectedIndex])
    }
    
    func setButtonTag() {
        for (index, button) in buttons.enumerated() {
            button.tag = index
        }
    }
    
} //:viewDidLoad



// MARK: - Actions
extension TabViewController {
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = vcList[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = vcList[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(tabView)
    }
    
   
}
