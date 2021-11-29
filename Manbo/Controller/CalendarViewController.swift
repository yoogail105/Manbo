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
    
    @IBOutlet weak var togleAlbumOnOff: UIButton!
    @IBOutlet weak var averageWeekLabel: UILabel!
    @IBOutlet weak var averageMonthLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    var isAlbumOn = true
    var headerVisible = true
    let formatter = DateFormatter()
    var isMonthView = true
    let calendar = Calendar.current
    var isSelectedDate = false
    var currentStepCount = UserDefaults.standard.currentStepCount {
        didSet {
            self.setAverageStepCounts()
        }
    }
  
    
    // cell color
    let outsideMonthColor = UIColor(hex: 0x4D4E51)
    let monthColor =  UIColor.label
    let selectedMonthColor = UIColor.label
    
    //View Controller
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        imageTintColorSettings()
        self.setupCalendarView()
        collectionView.delegate = self
        collectionView.dataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        setAverageStepCounts()
        
    
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
        
        
        
        naviItem()

    }//: VIEWDIDLOAD
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        currentStepCount = UserDefaults.standard.currentStepCount
        setupCalendarView()
        userNameLabel.text = UserDefaults.standard.name!
        
    }//: viewWillAppear
    
    @IBAction func reloadCalendar(_ sender: UIButton) {
        //let visibleDates = self.calendarView.visibleDates()
        //let date = calendarView.visibleDates().monthDates.first!.date
        let date = Date()
        calendarView.reloadData(withAnchor: date)
        view.layoutIfNeeded()
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            setupViewsOfCalendar(from: visibleDates)
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
                self.calendarView.reloadData(withAnchor: Date())
                self.setupViewsOfCalendar(from: visibleDates)
                
                //visibleDates.monthDates.first!.date
            }
        } else {
            isMonthView.toggle()
            toggleMonthWeek.setImage(UIImage(systemName: "m.square"), for: .normal)
            self.constraint.constant = 270
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendarView.reloadData(withAnchor: Date())
                self.setupViewsOfCalendar(from: visibleDates)
                
            })
        }
    }
        
        func setupCalendarView() {
            calendarView.minimumLineSpacing = 0
            calendarView.minimumInteritemSpacing = 0
            calendarView.reloadData(withAnchor: Date())
            calendarView.visibleDates { [unowned self] visibleDates in
                setupViewsOfCalendar(from: visibleDates)
            }
        }
        
        func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
            guard let startDate = visibleDates.monthDates.first?.date else { return
            }
            let month = calendar.dateComponents([.month], from: startDate).month!
            let monthName = self.formatter.monthSymbols[ (month-1) % 12]
            let year = calendar.component(.year, from: startDate)
            
            currentMonth.text = String(year) + "년 " + monthName
            //        self.currentMonth.text = self.formatter.string(from: date)
        }
        
    func setAverageStepCounts() {
        print(#function)
     
        averageWeekLabel.text = "\(userDefaults.weekStepCount! / Date().weekday)"
        averageMonthLabel.text = "\(userDefaults.monthStepCount! / Date().day)"
    }
    
    
    // MARK: - IsAlbumOn
    @IBAction func toggleAlbumOnOffButtonClicked(_ sender: UIButton) {
        
        isAlbumOn.toggle()
        collectionView.isHidden.toggle()
        
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
    
    func handleCelltextColor(view: JTACDayCell?, cellSTate: CellState) {
        guard let validCell = view as? DateCalendarViewCell else { return }
        
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
    
    
    func handleCellSelected(view: JTACDayCell?, cellSTate: CellState) {
        guard let validCell = view as? DateCalendarViewCell else { return }
        validCell.selectedView.cornerRounded(cornerRadius: 20)
        
        if validCell.isSelected {
            isSelectedDate = true
            calendarView.allowsMultipleSelection = true
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = monthColor
        } else {
            calendarView.allowsMultipleSelection = false
            isSelectedDate = false
            validCell.selectedView.isHidden = true
            validCell.dateLabel.textColor = monthColor
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
                                           calendar: self.calendar,
                                           firstDayOfWeek: .sunday)
            
        } else {
            return  ConfigurationParameters(startDate: startDate,
                                            endDate: endDate,
                                            numberOfRows: 1,
                                            calendar: self.calendar,
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
        
        guard let cell = cell as? DateCalendarViewCell else {return}
        cell.dateLabel.text = cellState.text
        configureVisibleCell(view: cell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    // MARK: - cellForItemAt
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCalendarViewCell.identifier, for: indexPath) as? DateCalendarViewCell else {
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
        guard let validCell = view as? DateCalendarViewCell else { return }
        
        validCell.dateLabel.text = cellState.text
        
        if self.calendar.isDateInToday(date) {
            print("오늘날짜configureVisibileCellD:\(calendar.isDateInToday(date))")
            validCell.contentView.cornerRounded(cornerRadius: 15)
            validCell.contentView.backgroundColor = UIColor.appColor(.mainGreen)
            print("실ㅇ행됨: \(date)")
        } else {
            validCell.contentView.backgroundColor = .clear
            
        }
        
        handleCelltextColor(view: validCell, cellSTate: cellState)
        
        if cellState.dateBelongsTo == .thisMonth && cellState.text == "1" {
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: date)
            print(month)
        }
        
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print("didSelectDate: \(date), CellState: \(cellState)")
        calendarView.allowsMultipleSelection = true
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCelltextColor(view: cell, cellSTate: cellState)
        print(cellState.date)
    }

    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        calendar.selectDates(calendar.selectedDates.filter({ $0 != date }))
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCelltextColor(view: cell, cellSTate: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewsOfCalendar(from: visibleDates)
        
        
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        handleCellSelected(view: cell, cellSTate: cellState)
        
        //        if self.calendar.isDateInToday(date) {
        //            handleCellSelected(view: cell, cellSTate: cellState)
        
        
        //        func handleCellSelected(view: JTACDayCell?, cellSTate: CellState) {
        //            guard let validCell = view as? DateCollectionViewCell else { return }
        //            validCell.selectedView.cornerRounded(cornerRadius: 20)
        //
        //            if validCell.isSelected {
        //                isSelectedDate = true
        //                validCell.selectedView.isHidden = false
        //            } else {
        //                isSelectedDate = false
        //                validCell.selectedView.isHidden = true
        //            }
        //        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        cell.dailyImage.image = UIImage(named: "manbo01")
        cell.cornerRounded(cornerRadius: 10)
        return cell
    }
    
}
