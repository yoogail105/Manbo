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
    var isAlbumOn = true
    var headerVisible = true
    let formatter = DateFormatter()
    var isMonthView = true
    let calendar = Calendar.current


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
        let name = UserDefaults.standard.name
        userNameLabel.text = name!
        print(name!)
        
        
        naviItem()

    }//: VIEWDIDLOAD
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        setupCalendarView()
    }//: viewWillAppear
    
    @IBAction func reloadCalendar(_ sender: UIButton) {
        //let visibleDates = self.calendarView.visibleDates()
        //let date = calendarView.visibleDates().monthDates.first!.date
        let date = Date()
        calendarView.reloadData(withAnchor: date)
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
