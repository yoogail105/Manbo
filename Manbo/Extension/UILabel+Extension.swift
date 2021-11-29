//
//  UILabel+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit

extension UILabel {
   
    func setTimeLabelUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.cornerRounded(cornerRadius: 5)
    }

}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
