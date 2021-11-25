//
//  CalendarViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit
import JTAppleCalendar
import SwiftUI

class CalendarViewController: UIViewController {
    static let identifier = "CalendarViewController"
    
    // calendar color
    let outsideMonthColor = UIColor(hex: 0x4D4E51)
    let monthColor =  UIColor.label
    let selectedMonthColor = UIColor.black
    
    let currentDateSelecedViewColor = UIColor.appColor(.borderLightGray)
    
    @IBOutlet weak var currentMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarFrameStackView: UIStackView!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var toggleMonthWeek: UIButton!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var collectonView: UICollectionView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    var headerVisible = true
    let formatter = DateFormatter()
    var isMonthView = true
    let testCalendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        imageTintColorSettings()
        setupCalendarView()
        collectionView.delegate = self
        collectionView.dataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        
        //calendarUI
        
        //calendarCollectionView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        calendarView.maskedCornerRounded(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        setupCalendarView()
    }
    
    @IBAction func reloadCalendar(_ sender: UIButton) {
        //let visibleDates = self.calendarView.visibleDates()
        //let date = calendarView.visibleDates().monthDates.first!.date
            let date = Date()
            calendarView.reloadData(withAnchor: date)
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                  self.setupViewsOfCalendar(from: visibleDates)
              }
        }
    
    // MARK: - toggle()
    @IBAction func toggleMonthAndWeekButtonClicked(_ sender: UIButton) {
        let visibleDates = self.calendarView.visibleDates()
        if isMonthView {
            isMonthView.toggle()
            toggleMonthWeek.setImage(UIImage(systemName: "w.square"), for: .normal)
            constraint.constant = 58.33
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                self.calendarView.reloadData(withAnchor: visibleDates.monthDates.first!.date)
                self.setupViewsOfCalendar(from: visibleDates)

                //visibleDates.monthDates.first!.date
            }
        } else {
            isMonthView.toggle()
            toggleMonthWeek.setImage(UIImage(systemName: "m.square"), for: .normal)
            self.constraint.constant = 270
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendarView.reloadData(withAnchor: visibleDates.monthDates.first!.date)
                self.setupViewsOfCalendar(from: visibleDates)

            })
        }
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
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "waveform.path"), style: .plain, target: self, action: #selector(settingButtonClicked))
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
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        self.calendarView.reloadData(withAnchor: Date())
        self.calendarView.visibleDates { [unowned self] visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    
    
    func handleCelltextColor(view: JTACDayCell?, cellSTate: CellState) {
        guard let validCell = view as? DateCollectionViewCell else { return }
        
        if validCell.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
            
        } else {
            if cellSTate.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else { return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = self.formatter.monthSymbols[ (month-1) % 12]
        let year = testCalendar.component(.year, from: startDate)
        
        self.currentMonth.text = String(year) + "년 " + monthName
//        self.currentMonth.text = self.formatter.string(from: date)
    }
    
    func handleCellSelected(view: JTACDayCell?, cellSTate: CellState) {
        guard let validCell = view as? DateCollectionViewCell else { return }
        validCell.selectedView.cornerRounded(cornerRadius: 20)
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    
}

extension CalendarViewController: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2021 09 01")!
        let endDate = formatter.date(from: "2022 12 31")!
        
        
        if isMonthView {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: 6,
                                           calendar: self.testCalendar,
                                           firstDayOfWeek: .sunday)
                                           
        } else {
            return  ConfigurationParameters(startDate: startDate,
                                            endDate: endDate,
                                            numberOfRows: 1,
                                            calendar: self.testCalendar,
                                            generateInDates: .forFirstMonthOnly,
                                            generateOutDates: .off,
                                            hasStrictBoundaries: false)
        }
        
    }
    
}
// MARK: - JTAC Delegate
extension CalendarViewController: JTACMonthViewDelegate {
    
    // MARK: - willDisplay: forItemat
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        guard let cell = cell as? DateCollectionViewCell else {return}
        cell.dateLabel.text = cellState.text
        configureVisibleCell(view: cell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    // MARK: - cellForItemAt
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
            return JTACDayCell()
        }
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCelltextColor(view: cell, cellSTate: cellState)
        
        configureVisibleCell(view: cell, cellState: cellState, date: date, indexPath: indexPath)
        
        return cell
        
    }
    
    
    // 오늘날짜 표시하기
    func configureVisibleCell(view: JTACDayCell?, cellState: CellState, date: Date, indexPath: IndexPath){
        guard let validCell = view as? DateCollectionViewCell else { return }

        validCell.dateLabel.text = cellState.text

        if self.testCalendar.isDateInToday(date) {
            print("오늘날짜configureVisibileCellD:\(testCalendar.isDateInToday(date))")
            validCell.contentView.cornerRounded(cornerRadius: 15)
            validCell.contentView.backgroundColor = UIColor.red
            print("실ㅇ행됨: \(date)")
        } else {
            validCell.contentView.backgroundColor = .clear

        }
   //     handleCellSelected(view: validCell, cellSTate: cellState)
        //      handleCellSelected(cell: myCustomCell, cellState: cellState)
    }
    
//    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//            // This function should have the same code as the cellForItemAt function
//        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
//            return JTACDayCell()
//        }
//        cell.dateLabel.text = cellState.text
//        handleCellSelected(view: cell, cellSTate: cellState)
//        handleCelltextColor(view: cell, cellSTate: cellState)
//
//
//            let myCustomCell = cell as! CellView
//            configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
//        }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCelltextColor(view: cell, cellSTate: cellState)
        print(cellState.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCelltextColor(view: cell, cellSTate: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        handleCellSelected(view: cell, cellSTate: cellState)
        return true
    }
    
    
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

// MARK: - CollectionVeiw
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
