//
//  ChatViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/12/02.
//

import UIKit

class ChatViewController: UIViewController {
        
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var manboImage: UIImageView!

        static let identifier = "ChatViewController"
        
        
    @IBOutlet weak var todayStepLabel: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
        
//            
            let dateFormatter = DateFormatter()
            let nowPercent = UserDefaults.standard.stepPercent
            manboImage.image = UIImage(named: self.setUserImage(userPercent: nowPercent!))
            let date = Date()
            dateFormatter.dateFormat = "yy.MM.dd"
            
            
            
            todayLabel.text = dateFormatter.string(from: date)
        let step = UserDefaults.standard.currentStepCount!
        todayStepLabel.text = "\(step.numberFormat())"
            
    
        }
}
            
            
            
    //        let request = URLRequest(url: url!)
    //        self.webView?.allowsBackForwardNavigationGestures = true


