//
//  DateCollectionViewCell.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/24.
//

import UIKit
import JTAppleCalendar

class DateCollectionViewCell: JTACDayCell {
    static let identifier = "DateCollectionViewCell"
    
    @IBOutlet weak var selectedCellView: UIView!

    @IBOutlet weak var dateLabel: UILabel!
    
}
