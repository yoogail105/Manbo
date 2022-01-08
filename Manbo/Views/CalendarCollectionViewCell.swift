//
//  CollectionViewCell.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    @IBOutlet weak var dailyImage: UIImageView!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //static let identifier = String(describing: CalendarViewCell.self)
    
    func configureCell(row: UserReport) {
        stepLabel.text = row.stepCount.numberFormat()
        dateLabel.text = row.date.replacingOccurrences(of: "-", with: ". ")
    }

        
        override func awakeFromNib() {
            super.awakeFromNib()
            

        }

    }
    
    
