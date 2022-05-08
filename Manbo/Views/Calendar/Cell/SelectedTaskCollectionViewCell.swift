//
//  SelectedTaskCollectionViewCell.swift
//
//
//  Created by minjoohehe on 2021/11/30.
//

import UIKit

class SelectedTaskCollectionViewCell: UICollectionViewCell {

    static let identifier = "SelectedTaskCollectionViewCell"

    @IBOutlet weak var borderView: UIView!
    @IBOutlet var dailyImage: UIImageView!
    @IBOutlet var dailyStepLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
