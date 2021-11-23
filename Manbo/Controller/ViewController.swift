//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit
import SideMenu
import HealthKit

class ViewController: UIViewController {
    static let identifier = "ViewController"
    // MARK: - PROPERTIES
    
    
    var healthStore = HKHealthStore()
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    var goal = ""
    @IBOutlet weak var currentStepCountLabel: UILabel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeHealthKit()
        
        
    
    }//: viewDidLoad
       
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        setUI()
        
    }
    
    // calendar에서는 보이도록
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        goal = String(UserDefaults.standard.stepsGoal!)
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(goal)"
        let currentStepCount = UserDefaults.standard.currentStepCount ?? 0
        
        currentStepCountLabel.text = String(currentStepCount)
    
        
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CustomSideMenuNavigationViewController") as? CustomSideMenuNavigationViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
        
    }
    
    
    //다른 뷰에서는 탭바 내려가도록한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
    
    // MARK: - HEALTHKIT
    // 접근 권한 허용
    func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) {(sucess, error) in
            if(sucess) {
                print("permission granted")
                self.getTodayTotalStepCounts()
            }

        }
    }


    func getTodayTotalStepCounts() {

        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else {
            return
        }

      //  let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)

        query.initialResultsHandler = {
            query, result, Error in

            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        let val = count.doubleValue(for: HKUnit.count())
                        print("Total step taken today is \(val) steps.")
                        UserDefaults.standard.currentStepCount = Int(val)
                    }
                }
            }
        }
        healthStore.execute(query)
    }
}


extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))!
    }
}
