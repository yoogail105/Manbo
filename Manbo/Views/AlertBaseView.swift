//
//  AlertBaseView.swift
//  Manbo
//
//  Created by 성민주민주 on 2022/06/05.
//

import UIKit
import SwiftUI


class AlertBaseView: UIView {
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = AlertViewText.setNotiTitmeTitle.rawValue
        return label
    }()
    
    let OKButton: UIButton = {
        let button = UIButton()
        button.setTitle(AlertButtonText.ok.rawValue, for: .normal)
        button.backgroundColor = UIColor.appColor(.mainGreen)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(AlertButtonText.cancel.rawValue, for: .normal)
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraints()
    }
    
    func constraints() {
        [label, OKButton, cancelButton].forEach {
            addSubview($0)
        }
        
        
    }
}
