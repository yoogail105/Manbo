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
    
    var isSelectedDate = false
    
    let formatter = DateFormatter()
    let calendar = Calendar.current
    let vc = CalendarViewController()
    
    // cell color
    let outsideMonthColor = UIColor(hex: 0x4D4E51)
    let monthColor =  UIColor.label
    let selectedMonthColor = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vc.calendarView.ibCalendarDelegate = self
        vc.calendarView.ibCalendarDataSource = self

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
            vc.calendarView.allowsMultipleSelection = true
            validCell.selectedView.isHidden = false
        } else {
            vc.calendarView.allowsMultipleSelection = false
            isSelectedDate = false
            validCell.selectedView.isHidden = true
        }
    }
}

extension DateCalendarViewCell: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2021 09 01")!
        let endDate = formatter.date(from: "2022 12 31")!
        
        
        if vc.isMonthView {
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
extension DateCalendarViewCell: JTACMonthViewDelegate {
    
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
        vc.calendarView.allowsMultipleSelection = true
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
        
        vc.setupViewsOfCalendar(from: visibleDates)
        
        
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
