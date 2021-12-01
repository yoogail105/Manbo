//
//  SettingBasicTableViewCell.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit

class SettingBasicTableViewCell: UITableViewCell {
    @IBOutlet weak var menuLable: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    static let identifier = "SettingBasicTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    // MARK: - VC로 데이터 전달
    
}
