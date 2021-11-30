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


class CalendarViewController: UIViewController {
    static let identifier = "CalendarViewController"
    
    let currentDateSelecedViewColor = UIColor.appColor(.borderLightGray)
    
    @IBOutlet weak var currentMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarFrameStackView: UIStackView!
    
    
    @IBOutlet weak var userImageView: UIImageView!
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
    let dateFormatter = DateFormatter()
    var isMonthView = true
    let calendar = Calendar.current
    var isSelectedDate = false {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentStepCount = UserDefaults.standard.currentStepCount {
        didSet {
            self.setAverageStepCounts()
        }
    }
    
    // 월이 바뀌면 헬스킷 데이터 받아오기
    var month = Date().month {
        didSet {
            
        }
    }
    var year = Date().year {
        didSet {
            
        }
    }
    //Realm
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    var selectedTask: UserReport?
    
    // cell color
    let outsideMonthColor = UIColor(hex: 0x4D4E51)
    let monthColor =  UIColor.label
    let selectedMonthColor = UIColor.label
    
    //HEALTHKIT
    let healthStore = HKHealthStore()
    
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
        setUserImage(userPercent: userDefaults.setpPercent!)
        
        
        let nibName = UINib(nibName: SelectedTaskCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: SelectedTaskCollectionViewCell.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeNameNotification), name: .nameNotification, object: nil)
        
        //calendarUI
        
        //calendarCollectionView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        calendarView.maskedCornerRounded(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        calendarFrameStackView.cornerRounded(cornerRadius: 20)
        calendarFrameStackView.layer.borderWidth = 2
        calendarFrameStackView.layer.borderColor = UIColor.appColor(.borderLightGray).cgColor
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        

        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
        
        naviItem()
        setupCalendarView()
        
    }//: VIEWDIDLOAD
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("calendarview", #function)
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
    
    // MARK: - HEalthkit download
    func thisMonthUserReports() {
        if healthStore.ishealthKitAuthorized() {
            healthStore.getThisMonthStepCounts()
            healthStore.getThisMonthStepCounts()
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
        let monthName = self.dateFormatter.monthSymbols[ (month-1) % 12]
        let year = calendar.component(.year, from: startDate)
        
        currentMonth.text = String(year) + "년 " + monthName
        //        self.currentMonth.text = self.formatter.string(from: date)
    }
    
    func setAverageStepCounts() {
        print(#function)
        
        let weekAverageStepCount = userDefaults.weekStepCount! / Date().weekday
        let monthAverageStepCount = userDefaults.monthStepCount! / Date().day
        averageWeekLabel.text = "이번주 평균 \(weekAverageStepCount.numberForamt())"
        averageMonthLabel.text = "이번달 평균 \(monthAverageStepCount.numberForamt())"
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
}
extension CalendarViewController: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
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
            validCell.contentView.cornerRounded(cornerRadius: 8)
            validCell.contentView.backgroundColor = UIColor.appColor(.mainGreen)
            //print("실행됨: \(date)")
        } else {
            validCell.contentView.backgroundColor = .clear
            
        }
        
        handleCelltextColor(view: validCell, cellSTate: cellState)
        
        // 다른 날 healthKIt 정보 내려받기
        
        if cellState.dateBelongsTo == .thisMonth && cellState.text == "1" {
            dateFormatter.dateFormat = "MMM"
            month = cellState.date.month
            year = cellState.date.year
            print("이번달이고, cellState.text(날짜가) 1일인 월 찾기: ", month)
        }
        
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print("didSelectDate: \(date), CellState: \(cellState)")
        calendarView.allowsMultipleSelection = true
        
        
        let SelectedDate = self.dateFormatter.simpleDateString(date: cellState.date)
        
        print(SelectedDate)
        guard localRealm.object(ofType: UserReport.self, forPrimaryKey: SelectedDate) != nil else {
            
            print("해당 날짜 없음.")
            return
        }
        self.selectedTask = localRealm.object(ofType: UserReport.self, forPrimaryKey: SelectedDate)!
        
        // print(filterdTask.first?.stepCount!)
    
        //print("row: \(cellState.row), day: \(cellState.day), date: \(cellState.date), text: \(cellState.text), cell: \(cellState.cell), column: \(cellState.column), dateBelongsTo: \(cellState.dateBelongsTo),dateSection: \(cellState.dateSection), isSelected: \(cellState.isSelected), selectedPosition: \(cellState.selectedPosition), selectionType: \(cellState.selectionType)")
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
        
        if isSelectedDate { //셀이 하나
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedTaskCollectionViewCell.identifier, for: indexPath) as! SelectedTaskCollectionViewCell
            
           let dailyData = self.selectedTask
             print("여기는 콜렉션뷰",self.selectedTask!)
            let userStep = dailyData?.stepCount
            let dailyStep = userStep?.numberForamt()
            
            cell.dailyStepLabel.text = dailyStep
            cell.backgroundColor = UIColor.init(hex: 0xF2E2DA)
            
            let userPercent = dailyData!.goalPercent
            print("userPercent는 \(dailyData!.goalPercent)")
            let userImageName = self.setUserImage(userPercent: userPercent)
            cell.dailyImage.image = UIImage(named: userImageName)
            cell.cornerRounded(cornerRadius: 10)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            cell.dailyImage.image = UIImage(named: "manbo01")
            cell.cornerRounded(cornerRadius: 10)
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSelectedDate {
            return CGSize(width: UIScreen.main.bounds.width * 0.9, height:
                            UIScreen.main.bounds.height * 0.1)
        } else {
            let cellSize = UIScreen.main.bounds.width / 5
            return CGSize(width: cellSize,height: cellSize)
            
        }
    }
    
    
}


