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
    
//    //callectionView 에서 사용하기
//    func configureCell(row: UserReport) {
////
////        memoTitleLabel.text = row.memoTitle
////        memoContentLabel.text = row.content
//    }
//
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - VC로 데이터 전달
    
}
