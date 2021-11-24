//
//  CalendarViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    static let identifier = "CalendarViewController"

    @IBOutlet weak var collectionView: UICollectionView!
    


    @IBOutlet weak var calendarFrameStackView: UIStackView!

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var calendarCollectionView: JTACMonthView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var collectonView: UICollectionView!
    var headerVisible = true
    let formatter = DateFormatter()
    
       override func viewDidLoad() {
           super.viewDidLoad()
           
           imageTintColorSettings()
           setupCalendarView()
           collectionView.delegate = self
           collectionView.dataSource = self
           calendarCollectionView.ibCalendarDelegate = self
           calendarCollectionView.ibCalendarDataSource = self
           
           //calendarUI
           
           calendarCollectionView.allowsMultipleSelection = true
           calendarCollectionView.allowsRangedSelection = true
           calendarCollectionView.maskedCornerRounded(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
           calendarFrameStackView.cornerRounded(cornerRadius: 20)
           calendarFrameStackView.layer.borderWidth = 2
           calendarFrameStackView.layer.borderColor = UIColor.appColor(.borderLightGray).cgColor
           
         
           
           let layout = UICollectionViewFlowLayout()
           let cellSize = UIScreen.main.bounds.width / 5
           layout.itemSize = CGSize(width: cellSize,height: cellSize)
           collectionView.collectionViewLayout = layout
           
           userNameLabel.text = UserDefaults.standard.name
           print("만보의 이름은 \(UserDefaults.standard.name)")
           naviItem()
           
       }
    
    // 간결하게 [ ]
    func imageTintColorSettings() {
        let leftButtonImage = UIImage(named: "chevron_left_icon.png")?.withRenderingMode(.alwaysTemplate)
        let rightButtonImage = UIImage(named: "chevron_right_icon.png")?.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(leftButtonImage, for: .normal)
        leftButton.tintColor = UIColor.lightGray
        rightButton.setImage(rightButtonImage, for: .normal)
        rightButton.tintColor = UIColor.lightGray
        
    }

    func naviItem() {
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "waveform"), style: .plain, target: self, action: #selector(settingButtonClicked))
        settingButton.tintColor = UIColor.label
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    @objc func settingButtonClicked() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CustomSideMenuNavigationViewController") as? CustomSideMenuNavigationViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
    
    }
    
    func setupCalendarView() {
        calendarCollectionView.minimumLineSpacing = 0
        calendarCollectionView.minimumInteritemSpacing = 0
    }

   }

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        cell.dailyImage.image = UIImage(named: "manbo01")
        cell.cornerRounded(cornerRadius: 10)
        return cell
    }

}

extension CalendarViewController: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCollectionViewCell else {return}
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
            return JTACDayCell()
        }
        cell.dateLabel.text = cellState.text

        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let validCell = cell as? DateCollectionViewCell else {return}
        
        validCell.selectedCellView.isHidden = false
        validCell.selectedCellView.cornerRounded(cornerRadius: 20)
    
    }
         
    
    
//    func configureCell(view: JTAppleCell?, cellState: CellState) {
//       guard let cell = view as? DateCell  else { return }
//       cell.dateLabel.text = cellState.text
//       handleCellTextColor(cell: cell, cellState: cellState)
//    }
//        
//    func handleCellTextColor(cell: DateCell, cellState: CellState) {
//       if cellState.dateBelongsTo == .thisMonth {
//          cell.dateLabel.textColor = UIColor.black
//       } else {
//          cell.dateLabel.textColor = UIColor.gray
//       }
//    }
//    
    
}

extension CalendarViewController: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2021 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }

}
