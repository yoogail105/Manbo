//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit
import SideMenu
import HealthKit
//import RealmSwift
//import CoreLocation


class ViewController: UIViewController {
    static let identifier = "ViewController"
    // MARK: - PROPERTIES
    
    
    var healthStore = HKHealthStore()
    
    //time
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    var date = Date()
    
    //CoreLocation
    //let locationManager = CLLocationManager()
    //var locationAuthorization = false
    
    
    //  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var currentStepCountLabel: UILabel!
    var stepGoal = 0
    var stepCount: Int = 0 {
        didSet {
            print("stepCount 업데이트")
            currentStepCountLabel.text = String(stepCount)
        }
    }
    var stepPercent = 0.0
    var userImage = Manbo.manbo00
    
    /*
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.appColor(.mainGreen)
        
        return refreshControl
    }()*/
  
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        
        // locationManager.delegate = self
        
        // scrollView.addSubview(self.refreshControl)
        
    }//: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("main",#function)
        self.navigationController?.isNavigationBarHidden = true
        authorizeHealthKit()
        getUserInformation()
        setUI()
    }//: viewWillLoad
    
    /*
    @objc func handleRefresh(_ refershControl: UIRefreshControl) {
        
        authorizeHealthKit()
        getUserInformation()
        setUI()
        
        refreshControl.endRefreshing()
    }*/
    
   
    
    // calendar에서는 보이도록
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getUserInformation() {
        let userDefaults = UserDefaults.standard
        
        stepGoal = userDefaults.stepsGoal ?? 5000
        stepPercent = userDefaults.setpPercent ?? 0.0
        //resetTime = userDefaults.setpPercent ?? "00:00"
        //notiTime = userDefaults.notiTime ?? "00:00"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        print("main: ", #function)
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(String(stepGoal))"
        
        setUserImage()
        
    }
    
    func setUserImage() {
        print("main: ", #function)
        switch stepPercent {
        case 0.0 ..< 30.0:
            userImage = Manbo.manbo00
        case 30.0 ..< 50.0:
            userImage = Manbo.manbo01
        case 50.0 ..< 80.0:
            userImage = Manbo.manbo02
        case 80.0 ..< 100.0:
            userImage = Manbo.manbo03
        default:
            userImage = Manbo.manbo100
        }
        
        userImageView.image = UIImage(named: userImage.rawValue)
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
        print("main: ", #function)
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
        print("main",#function)
        
        let hour = resetTime().hour
        let minute = resetTime().minute
        
        //오늘, 새벽 2시부터 내일 새벽 2시까지
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        
        //let dateComponents = DateComponents(year: 2021, month: 11, day: 23, hour: hour, minute: minute)
        let startDate = calendar.date(from: dateComponents)
        let endDate = calendar.date(byAdding: .hour, value: 24, to: startDate!)
        var totalCount = 0.0
        print(date)
        print(startDate!, endDate!)
        
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        var interval = DateComponents()
        interval.minute = 60
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate!, intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, result, Error in
            
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate!, to:endDate!) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        
                        let val = count.doubleValue(for: HKUnit.count())
                        print("count: \(val) steps.")
                        totalCount += val
                    }
                    
                }
                UserDefaults.standard.currentStepCount = Int(totalCount)
                print(totalCount)
            }
            //            DispatchQueue.main.async {
            //                completion(sum.doubleValue(for: HKUnit.count()))
            //            }
        }
        healthStore.execute(query)
    }
    
    func resetTime() -> (hour: Int, minute: Int){
        print("main",#function)
        
        //유저가 선택한 시간 가져오기
        
        let resetTimeString = UserDefaults.standard.resetTime
        dateFormatter.dateFormat = "HH:mm"
        let resetTime = dateFormatter.date(from: resetTimeString!)
        let hour = calendar.component(.hour, from: resetTime!)
        let minute = calendar.component(.minute, from: resetTime!)
        return (hour: hour, minute: minute)
    }
    
    
    func getAWeekTotalStepCounts() {
        print("main",#function)
        
        
        let hour = resetTime().hour
        let minute = resetTime().minute
        
        //오늘, 새벽 2시부터 내일 새벽 2시까지
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        
        //let dateComponents = DateComponents(year: 2021, month: 11, day: 23, hour: hour, minute: minute)
        let startDate = calendar.date(from: dateComponents)
        let endDate = calendar.date(byAdding: .hour, value: 24, to: startDate!)
        var totalCount = 0.0
        print(date)
        print(startDate!, endDate!)
        
        
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        //  let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        var interval = DateComponents()
        interval.minute = 60
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate!, intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, result, Error in
            
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate!, to:endDate!) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        
                        let val = count.doubleValue(for: HKUnit.count())
                        print("count: \(val) steps.")
                        totalCount += val
                    }
                    
                }
                UserDefaults.standard.currentStepCount = Int(totalCount)
                print(totalCount)
            }
            //            DispatchQueue.main.async {
            //                completion(sum.doubleValue(for: HKUnit.count()))
            //            }
        }
        healthStore.execute(query)
    }
    
    //    func locationSettingAlert() {
    //        showAlert(title: "위치 서비스를 사용할 수 없습니다.", message: "지도에서 내 위치를 확인하여 https://evan-moon.github.io/2020/04/07/about-restful-api/ 정보를 얻기 위해 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", okTitle: "설정으로 이동") {
    //            guard let url = URL(string: UIApplication.openSettingsURLString) else {
    //                return
    //            }
    //            if UIApplication.shared.canOpenURL(url){
    //                UIApplication.shared.open(url) { success in
    //                    print("설정으로 이동했습니다.")
    //                }
    //            }
    //
    //        }
    //    } //: locationSettingAlert
    
}



//extension Date {
//    static func mondayAt12AM() -> Date {
//        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))!
//    }
//}



//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(#function)
//
//        if let coordinate = locations.last?.coordinate {
//            getCurrentAddress(location: locations[0])
//        } else {
//            print("주소 없음 얼럿")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(#function)
//    }
//    //처음 실행하는 경우, 권한이 변경된 경우
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print(#function)
//        //check
//    }
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print(#function)
//        //check
//    }

