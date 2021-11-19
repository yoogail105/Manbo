//
//  CameraViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var backupLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    static let identifier = "CameraViewController"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backupLabel.text = NSLocalizedString("data_backup", tableName: "Setting", bundle: .main, value: "", comment: "")
    }

}



