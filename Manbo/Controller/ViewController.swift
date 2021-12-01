//
//  ViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit
import SideMenu
import HealthKit
import RealmSwift
import CoreLocation
import NotificationBannerSwift


class ViewController: UIViewController {
    static let identifier = "ViewController"
    // MARK: - PROPERTIES
    
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    // healthStore
    var healthKitAuthorization = false
    var healthStore: HKHealthStore?
    var totalStepCount = 0.0
    var SevenDaysStepCounts = 0
    var ThisWeekStepCounts = 0
    var ThisMonthStepCounts = 0
    var last30DaysStepCount = false
    
    //time
    var today = Date()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    //Realm
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    
    //CoreLocation
    let locationManager = CLLocationManager()
    var locationAuthorization = false
    var notificationAuthorization = false
    var currentLocation: CLLocation?
    var latitude = 37.566403559824955
    var longitude = 126.97794018074802
    
    //  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var currentStepCountLabel: UILabel!
    var userImage = Manbo.manbo00
    //userDefaults
    let userDefaults = UserDefaults.standard
    
    var stepGoal = UserDefaults.standard.stepsGoal!
    var stepPercent = UserDefaults.standard.setpPercent! {
        didSet {
            //print("퍼센테이지 바꼈다.")
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(named: self.userImage.rawValue)
            }
        }
    }
    var currentStepCount = UserDefaults.standard.currentStepCount! {
        didSet{
            //print("걸음수값 변경되었다.")
            DispatchQueue.main.async {
                self.currentStepCountLabel.text = self.currentStepCount.numberForamt()
                self.setUserImage()
            }
        }
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main", #function)
        //  UserDefaults.standard.hasOnbarded = false
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        dateFormatter.basicDateSetting()
        
        locationManager.delegate = self
        
        checkUserLoactionServicesAuthorization()
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            self.notiBanenr(notiText: "만보랑은 아이폰에서 사용이 가능합니다🐾")
        }
        
        if healthStore != nil {
            if ((healthStore?.ishealthKitAuthorized()) != nil) {
                print("헬스킷Ok")
                self.getTodayStepCounts()
                healthStore?.getThisWeekStepCounts()
                healthStore?.getThisMonthStepCounts()
                if !last30DaysStepCount {
                    healthStore?.getNDaysStepCounts(number: 30)
                }
                
            } else {
                //   헬스킷 권한 요청한다.
                healthStore!.authorizeHealthKit()
            }
        }
        
        setUI()
        setUserImage()
        SetNotiViewController().requestNotificationAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeGoalNotification), name:.goalNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeResteTimeNotification), name:.stepNotification, object: nil)
        
        
    }//: viewDidLoad
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("main",#function)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if healthStore != nil {
            if ((healthStore?.ishealthKitAuthorized()) != nil) {
                self.getTodayStepCounts()
                healthStore?.getThisWeekStepCounts()
                healthStore?.getThisMonthStepCounts()
                if !last30DaysStepCount {
                    healthStore?.getNDaysStepCounts(number: 30)
                }
                
            } else {
                //   헬스킷 권한 요청한다.
                healthStore!.authorizeHealthKit()
            }
        }
        
        
    }//: viewWillAppear
    
    
    // calendar에서는 보이도록
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("main:", #function)
        self.navigationController?.isNavigationBarHidden = false
        
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(userDefaults.stepsGoal!.numberForamt())"
    }//: viewWillAppear
    
    @objc func changeGoalNotification(notification: NSNotification) {
        
        if let newGoal = notification.userInfo?["myValue"] as? Int {
            goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(newGoal.numberForamt())"
            setUserImage()
        }
    }
    
    func getLocation() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    @objc func changeResteTimeNotification(notification: NSNotification) {
        if let currentStep = notification.userInfo?["newStep"] as? Int {
            currentStepCountLabel.text = "\(currentStep.numberForamt())"
            setUserImage()
        }
    }
    
    func getLastConnection() {
        UserDefaults.standard.lastConnection = Date()
        print(UserDefaults.standard.lastConnection!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        print("main: ", #function)
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(stepGoal.numberForamt())"
        let stepText = userDefaults.currentStepCount!.numberForamt()
        currentStepCountLabel.text = "\(String(describing: stepText))"
    }
    
    func setUserImage() {
        print("main: percente \(stepPercent)", #function)
        stepPercent = userDefaults.setpPercent!
        switch stepPercent {
        case 0.0 ..< 0.3:
            userImage = Manbo.manbo00
        case 0.3 ..< 0.5:
            userImage = Manbo.manbo01
        case 0.5 ..< 0.8:
            userImage = Manbo.manbo02
        case 0.8 ..< 1.0:
            userImage = Manbo.manbo03
        default:
            userImage = Manbo.manbo100
        }
    }
    
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: CustomSideMenuNavigationViewController.identifier) as? CustomSideMenuNavigationViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
        
    }
    
    func notiBanenr(notiText: String) {
        let banner = NotificationBanner(title: notiText, subtitle: "", leftView: nil, rightView: nil, style: .info, colors: nil)
        
        banner.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            banner.dismiss()
        })
    }
    
    
    //다른 뷰에서는 탭바 내려가도록한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
    
    
    func setDefaultLocation() {
        currentLocation = CLLocation(latitude: 37.566403559824955, longitude: 126.97794018074802)
    }
    
    // MARK: - HEALTHKIT
    // UI바뀌어야 해서,,
    func getTodayStepCounts()  {
        healthStore!.getToalStepCounts(passedDays: 0) { (result) in
            DispatchQueue.main.async {
                self.currentStepCount = Int(result)
                UserDefaults.standard.currentStepCount = self.currentStepCount
            }
        }
    }
    
    func fetchWeather() {
        OpenWeatherAPIManager.shared.fetchWeatherInformation(latitude: latitude, longitude: longitude) { temp  in
            
            
            let currentTemp = Int(temp)
            self.weatherTempLabel.text = "\(currentTemp)°C"
            
            
        }
    }
    
}

//     MARK: - getToalStepCounts -> HealthKit Extension



// MARK: - LOCATION
extension ViewController: CLLocationManagerDelegate {
    
    func checkUserLoactionServicesAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
    
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요 alert")
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("메인: ", #function)
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치권한: 권한 설정ok")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("위치권한: 권한이 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("위치권한: 요청을 거부함")
            setDefaultLocation()
        default:
            print("위치권한:  디폴트")
            setDefaultLocation()
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("메인: ", #function)
        
        if let location = locations.last {
            self.currentLocation = location
            
            locationManager.stopUpdatingLocation()
            latitude = self.currentLocation!.coordinate.latitude
            longitude = self.currentLocation!.coordinate.longitude
            
            
        } else {
            latitude = 37.566403559824955
            longitude = 126.97794018074802
        }
        
        fetchWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
    
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationAuthorization = false
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .restricted, .denied:
            locationAuthorization = false
            print("설정으로")
        case .authorizedAlways:
            locationAuthorization = true
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationAuthorization = true
        case .authorized:
            print("default")
        @unknown default:
            print("default")
        }
        if #available(iOS 14.0, *) {
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .reducedAccuracy:
                print("reduce")
            case .fullAccuracy:
                print("fullAccuraty")
            @unknown default:
                print("default")
            }
        }
        
    }
    
}


