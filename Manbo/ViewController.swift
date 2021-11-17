//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tabBarBottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weatherStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem()
    }
    func naviItem() {
        let weatherButton = UIButton(type: .custom)
        //weatherButton.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        weatherButton.setImage(UIImage(named: "sunny"), for: .normal)

        let menuBarItem = UIBarButtonItem(customView: weatherButton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
            currWidth?.isActive = true
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30)
            currHeight?.isActive = true


        let airButton = UIButton(type: .custom)
        airButton.setImage(UIImage(named: "good.png"),for: .normal)
        let airBarButton = UIBarButtonItem(customView: airButton)
        let currWidth2 = airBarButton.customView?.widthAnchor.constraint(equalToConstant: 30)
            currWidth2?.isActive = true
            let currHeight2 = airBarButton.customView?.heightAnchor.constraint(equalToConstant: 30)
            currHeight2?.isActive = true
        self.navigationItem.leftBarButtonItems = [menuBarItem, airBarButton]
       
    }

    @IBAction func settingButtonClicked(_ sender: Any) {
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func mainButtonCilicked(_ sender: UIButton) {
    }
    @IBAction func calendarButtonClicked(_ sender: UIButton) {
    }
    
        //다른 뷰에서는 탭바 내려가도록한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
}

