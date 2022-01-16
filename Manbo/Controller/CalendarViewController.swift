//
//  CalendarViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit
import JTAppleCalendar
import RealmSwift
import HealthKit
import NotificationBannerSwift
import SwiftUI


class CalendarViewController: UIViewController {
    
    static let identifier = "CalendarViewController"
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    
    let currentDateSelectedViewColor = UIColor.appColor(.borderLightGray)
    
    @IBOutlet weak var currentMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarFrameStackView: UIStackView!
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var toggleMonthWeek: UIButton!
    @IBOutlet weak var calendarView: JTACMonthView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var togleAlbumOnOff: UIButton!
    @IBOutlet weak var averageWeekLabel: UILabel!
    @IBOutlet weak var averageMonthLabel: UILabel!
    
    
    // calendar에 색상 표시하기
    var calendarDataSource: [String:String] = [:]
    let dateFormatter = DateFormatter()
    
    
    let userDefaults = UserDefaults.standard
    var isAlbumOn = true
    var showInfoView = false
    var headerVisible = true
    var isMonthView = true
    let calendar = Calendar.current

    var isSelectedDate = false {
        didSet {
            collectionView.reloadData()
            if isSelectedDate {
                detailLabel.text = "👇 선택한 날에 만보와 산책한 기록을 확인할 수 있어요!"
            } else {
                detailLabel.text = "👇 만보의 모습을 통해 그동안의 목표 달성률을 확인할 수 있어요!"
            }
        }
    }
    var currentStepCount = UserDefaults.standard.currentStepCount {
        didSet {
            self.calculateThisMonthAverageStepCounts()
        }
    }
    
    var calendarMonth = Date().month
    var calendarYear = Date().year {
        didSet {
            self.calculatePastMonthAverageStepCounts()
        }
    }

    var weekAverageStepCount = 0
    //Realm
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    var selectedTask: UserReport?
    
    // cell color
    let outsideMonthColor = UIColor(named: "outDatetedColor")
    //    let outsideMonthColor = UIColor(hex: 0x4D4E51)
    let monthColor =  UIColor.label
    let selectedMonthColor = UIColor.label
    
    //HEALTHKIT
    let healthStore = HKHealthStore()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CalendarViewController:", #function)
        imageTintColorSettings()
        
        self.setupCalendarView()
        collectionView.delegate = self
        collectionView.dataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        
        calculateThisMonthAverageStepCounts()
        print("초기 값: ", UserDefaults.standard.currentStepCount!)
        
        let nibName = UINib(nibName: SelectedTaskCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: SelectedTaskCollectionViewCell.identifier)
        
        //calendarUI
        populateDataSource()
        
        //calendarCollectionView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        calendarView.maskedCornerRounded(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        calendarFrameStackView.cornerRounded(cornerRadius: 20)
        calendarFrameStackView.layer.borderWidth = 2
        calendarFrameStackView.layer.borderColor = UIColor.appColor(.borderLightGray).cgColor
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
        
        var monthlyTasks: Results<UserReport>!
        monthlyTasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false).filter("date CONTAINS [c] '2022-01-'")
        print("전체 tasks 프린트:", monthlyTasks)
        
        naviItem()
        setUpDetailView()
        
        // MARK: - NOTIFICATION
        NotificationCenter.default.addObserver(self, selector: #selector(changeNameNotification), name: .nameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeImageNotification), name:.updateImageNotification, object: nil)
        
        let nowPercent = userDefaults.stepPercent
        userImageView.image = UIImage(named: "\(self.setUserImage(userPercent: nowPercent!))")
    }//: VIEWDIDLOAD
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("calendarView", #function)
        currentStepCount = userDefaults.currentStepCount
        setupCalendarView()
        userNameLabel.text = userDefaults.name!
        
        
    }//: viewWillAppear
    
    @objc func changeNameNotification(notification: NSNotification) {
        if let text = notification.userInfo?["newName"] as? String {
            userNameLabel.text = text
        }
    }
    
    
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
    
    // MARK: - HealthKit download
    func thisMonthUserReports() {
        //        if healthStore.ishealthKitAuthorized() {
        //            healthStore.getThisMonthStepCounts()
        //            healthStore.getThisMonthStepCounts()
        //        }
        //
        
    }
    
    func setUpDetailView() {
        detailView.layer.borderWidth = 1
        detailView.layer.borderColor = UIColor.lightGray.cgColor
        detailView.cornerRounded(cornerRadius: 8)
    }
    
    // MARK: - toggle()
    @IBAction func toggleMonthAndWeekButtonClicked(_ sender: UIButton) {
        let visibleDates = self.calendarView.visibleDates()
        if isMonthView {
            isMonthView.toggle()
            toggleMonthWeek.setImage(UIImage(systemName: "w.square"), for: .normal)
            constraint.constant = 50.0
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
        print(#function)
        guard let startDate = visibleDates.monthDates.first?.date else { return
        }
        
        calendarMonth = calendar.dateComponents([.month], from: startDate).month!
        calendarYear = calendar.component(.year, from: startDate)
        
        
        currentMonth.text = String(calendarYear) + "년 " + String(calendarMonth) + "월"
    }
    
    func calculateThisMonthAverageStepCounts() {
        print("CalendarView", #function)
        
        
        weekAverageStepCount = userDefaults.weekStepCount! / Date().weekday
        let thisMonthAverageStepCount = AverageStepCountManager.shared.calculateMonthlyAverageStepCount(year: Date().year, month: Date().month)
    
        averageMonthLabel.text = "이번달 평균 \(thisMonthAverageStepCount.numberFormat())"
        
    }
    
    func calculatePastMonthAverageStepCounts() {
        
        let monthlyAverageStepCount = AverageStepCountManager.shared.calculateMonthlyAverageStepCount(year: calendarYear, month: calendarMonth)
        
        if calendarMonth == Date().month {
        averageWeekLabel.text = "이번주 평균 \(weekAverageStepCount.numberFormat())"
        } else {
            averageWeekLabel.text = "\(calendarMonth)월 평균 \(monthlyAverageStepCount.numberFormat())"
            print("달라졌음.")
        }
     
        
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
    
    func handleCellTextColor(view: JTACDayCell?, cellSTate: CellState) {
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
        validCell.selectedView.cornerRounded(cornerRadius: 8)
        
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
    
    @objc func changeImageNotification(notification: NSNotification) {
        
        if let newImage = notification.userInfo?["ImageName"] as? String {
            self.userImageView.image = UIImage(named: newImage)
        }
    }
    
    func notiBanner(notiText: String) {
        let banner = NotificationBanner(title: notiText, subtitle: "", leftView: nil, rightView: nil, style: .info, colors: nil)
        
        banner.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            banner.dismiss()
        })
    }
    
    func setColorTag(percent: Double) -> UIColor {
        var tagColor = UIColor.calendarColor(.first)
        switch percent {
        case 0.0 ..< 0.33:
            tagColor = UIColor.calendarColor(.first)
        case 0.33 ..< 0.66:
            tagColor = UIColor.calendarColor(.second)
        case 0.66 ..< 1.0:
            tagColor = UIColor.calendarColor(.third)
        default:
            tagColor = UIColor.calendarColor(.fourth)
        }
        
        return tagColor
    }
    
    func populateDataSource() {
        // You can get the data from a server.
        // Then convert that data into a form that can be used by the calendar.
        calendarDataSource = [
            "2021-12-01": "2021-12-01",
            "2021-12-02": "2021-12-01",
            "2021-12-03": "2021-12-01",
            "2021-12-04": "2021-12-01",
        ]
        // update the calendar
        calendarView.reloadData()
    }
    
    func handleCellEvents(cell: DateCalendarViewCell, cellState: CellState) {
        print("handleCellEvents",#function)
        let dateString = dateFormatter.simpleDateString(date: cellState.date)
        print("dateString:", dateString)
        //            if calendarDataSource[dateString] == nil {
        //                print("nil")
        //                cell.colorView.isHidden = true
        //            } else {
        //                cell.colorView.isHidden = false
        //            }
    }
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        print("configureCell",#function)
        guard let cell = view as? DateCalendarViewCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(view: view, cellSTate: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        
    }
    
    
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        showInfoView.toggle()
        detailView.isHidden.toggle()
        self.collectionView.reloadData()
        
        if showInfoView == true {
            detailLabel.textColor = .lightGray
            detailLabel.font = .systemFont(ofSize: 12)
            detailLabel.numberOfLines = 0
        }
        
    }
}

// MARK: - CalendarViewController
extension CalendarViewController: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let firstDate = userDefaults.firstLaunchDate!
        
        //앱 런치 기준 지난 달의 첫날부터
        let startDate = firstDate.startOfMonth().startOfLastMonth
        
        // 지금 달의 마지막날까지 달력 표시
        let endDate = Date().startOfMonth().endOfThisMonth
        
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
    
    // MARK: - cellForItemAt
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCalendarViewCell.identifier, for: indexPath) as? DateCalendarViewCell else {
            return JTACDayCell()
        }
        // let calendarDate = dateFormatter.simpleDateString(date: cellState.date)
        
        cell.dateLabel.text = cellState.text
        print(cellState.date)
        //        let image = UIImage(named: "calShapeEx.png")?.withRenderingMode(.alwaysTemplate)
        //        cell.calendarColorImage.image = image
        //        let row = indexPath.row
        //
        //            let thisColor = self.setColorTag(percent: tasks[row].goalPercent)
        //            cell.calendarColorImage.tintColor = thisColor
        //
        //tasks[row].goalPercent
        
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCellTextColor(view: cell, cellSTate: cellState)
        configureVisibleCell(view: cell, cellState: cellState, date: date, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - willDisplay: forItemat
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        configureCell(view: cell, cellState: cellState)
        
        guard let cell = cell as? DateCalendarViewCell else {return}
        cell.dateLabel.text = cellState.text
        configureVisibleCell(view: cell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    
    
    
    // 오늘날짜 표시하기
    func configureVisibleCell(view: JTACDayCell?, cellState: CellState, date: Date, indexPath: IndexPath){
        guard let validCell = view as? DateCalendarViewCell else { return }
        
        validCell.dateLabel.text = cellState.text
        
        if self.calendar.isDateInToday(date) {
            // 오늘 날짜
            validCell.contentView.cornerRounded(cornerRadius: 8)
            validCell.contentView.backgroundColor = UIColor.appColor(.mainGreen)
        } else {
            validCell.contentView.backgroundColor = .clear
            
        }
        
        handleCellTextColor(view: validCell, cellSTate: cellState)
        
        // 다른 날 healthKIt 정보 내려받기
        
        if cellState.dateBelongsTo == .thisMonth && cellState.text == "1" {
            dateFormatter.dateFormat = "MMM"
            let month = cellState.date.month // 이번 달
            let year = cellState.date.year
             print("이번달이고, cellState.text(날짜가) 1일인 월 찾기: ", month)
        }
        
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        //        print("didSelectDate: \(date), CellState: \(cellState)")
        calendarView.allowsMultipleSelection = true
        
        
        let SelectedDate = self.dateFormatter.simpleDateString(date: cellState.date)
        
        // print(SelectedDate)
        //        guard localRealm.object(ofType: UserReport.self, forPrimaryKey: SelectedDate) != nil else {
        //            // self.notiBanner(notiText: "이날도 만보랑 걸어주실거죠?")
        //           // print("해당 날짜 없음.")
        //            return
        //        }
        self.selectedTask = localRealm.object(ofType: UserReport.self, forPrimaryKey: SelectedDate)
        //! 지움
        
        // print(filterdTask.first?.stepCount!)
        
        //print("row: \(cellState.row), day: \(cellState.day), date: \(cellState.date), text: \(cellState.text), cell: \(cellState.cell), column: \(cellState.column), dateBelongsTo: \(cellState.dateBelongsTo),dateSection: \(cellState.dateSection), isSelected: \(cellState.isSelected), selectedPosition: \(cellState.selectedPosition), selectionType: \(cellState.selectionType)")
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCellTextColor(view: cell, cellSTate: cellState)
        // print(cellState.date)
    }
    
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        calendar.selectDates(calendar.selectedDates.filter({ $0 != date }))
        
        handleCellSelected(view: cell, cellSTate: cellState)
        handleCellTextColor(view: cell, cellSTate: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewsOfCalendar(from: visibleDates)
        
        
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        handleCellSelected(view: cell, cellSTate: cellState)
        
        return true
    }
    
}

// MARK: - CollectionVeiw
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSelectedDate {
            return 1
        } else {
            return tasks.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        func settingCell(cell: UICollectionViewCell) {
            cell.backgroundColor = UIColor.init(hex: 0xF2E2DA)
            cell.cornerRounded(cornerRadius: 10)
        }
        
        if isSelectedDate { //셀이 하나
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedTaskCollectionViewCell.identifier, for: indexPath) as! SelectedTaskCollectionViewCell
            
            // 정보가 있으면
            if self.selectedTask != nil {
                
                let dailyData = self.selectedTask
                let userStep = dailyData?.stepCount
                let dailyStep = userStep?.numberFormat()
                
                cell.dailyStepLabel.text = dailyStep
                // cell.backgroundColor = UIColor.init(hex: 0xF2E2DA)
                
                let userPercent = dailyData!.goalPercent
                // print("userPercent는 \(dailyData!.goalPercent)")
                let userImageName = self.setUserImage(userPercent: userPercent)
                cell.dailyImage.image = UIImage(named: userImageName)
                // cell.cornerRounded(cornerRadius: 10)
                
            } else { //걸음 정보가 없으면
                
                cell.dailyImage.image = UIImage(named: "manbo03")
                cell.dailyStepLabel.adjustsFontSizeToFitWidth = true
                cell.dailyStepLabel.text = "이 날에도 같이 걸어 주실거죠?"
                
            }
            
            settingCell(cell: cell)
            return cell
            
        } else { // 특정 날짜가 선택되지 않았다면 -> 셀이 여러개: 전체 기록
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            cell.dailyImage.image = UIImage(named: "manbo01")
            cell.cornerRounded(cornerRadius: 10)
            
            let row = tasks[indexPath.row]
            let imageName = setUserImage(userPercent: row.goalPercent)
            cell.dailyImage.image = UIImage(named: imageName)
            settingCell(cell: cell) // UI 설정임
            
            if showInfoView {
                cell.infoView.isHidden = false
                cell.configureCell(row: row)
            } else {
                cell.infoView.isHidden = true
            
            }
            
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSelectedDate {
            return CGSize(width: UIScreen.main.bounds.width * 0.88, height:
                            UIScreen.main.bounds.height * 0.1)
        } else {
            let cellSize = UIScreen.main.bounds.width / 5
            return CGSize(width: cellSize,height: cellSize)
            
        }
    }
    
    
}


