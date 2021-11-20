//
//  CustomSideMenuNavigationViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/20.
//

import UIKit
import SideMenu

class CustomSideMenuNavigationViewController: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        //self.statusBarEndAlpha = 0.0
        self.menuWidth = self.view.frame.width * 0.55
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
