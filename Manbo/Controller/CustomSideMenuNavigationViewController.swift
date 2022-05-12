//
//  CustomSideMenuNavigationViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//

import UIKit
import SideMenu

final class CustomSideMenuNavigationViewController: SideMenuNavigationController {
    
    static let identifier = "CustomSideMenuNavigationViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        //self.statusBarEndAlpha = 0.0
        self.menuWidth = self.view.frame.width * 0.7
        // Do any additional setup after loading the view.
        
    }
    

}
