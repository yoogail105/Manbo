//
//  NameView.swift
//  Manbo
//
//  Created by 성민주민주 on 2022/06/07.
//

import UIKit
import SwiftUI



class NameView: AlertBaseView {
    let manboImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Manbo.manbo00.rawValue)
        return imageView
    }()
    
    let nameTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = AlertText.namePlaceHolder.rawValue
        return textField
    }()
    
    override func constraints() {
        super.constraints
        [manboImageView, nameTextField].forEach {
            addSubview($0)
        }
    }
    
}
