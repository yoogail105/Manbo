//
//  DateCalendarViewCell.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/24.
//

import UIKit
import JTAppleCalendar

class DateCalendarViewCell: JTACDayCell {
    static let identifier = "DateCalendarViewCell"
    //static let identifier = String(describing: DateCalendarViewCell.self)

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
      

    }
    
   
    
    
}

