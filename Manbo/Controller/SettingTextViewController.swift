//
//  SettingTextViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit

class SettingTextViewController: UIViewController {
    static let identifier = "SettingTextViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }

    
    @objc func closeButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}
