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
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet var buttons:[UIButton]!
    @IBOutlet var tabView:UIView!
    var footerHeight: CGFloat = 30
    
    static let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.identifier)
    static let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraViewController.identifier)
    static let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.identifier)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // tabView.backgroundColor = .clear
        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        
        viewControllers.append(TabViewController.mainVC)
        viewControllers.append(TabViewController.cameraVC)
        viewControllers.append(TabViewController.calendarVC)
        
        print(viewControllers)
        print(buttons)
        buttons[selectedIndex].isSelected = true
        tabChanged(sender: buttons[selectedIndex])
    }
}

// MARK: - Actions
extension TabViewController {
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
    
   
}
