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
import Firebase

class ViewController: UIViewController {
    static let identifier = "ViewController"
    // MARK: - PROPERTIES
    
    @IBOutlet weak var healthKItInform: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    // healthStore
    var healthKitAuthorization = UserDefaults.standard.healthKitAuthorization
    var healthStore: HKHealthStore?
    var totalStepCount = 0.0
    var SevenDaysStepCounts = 0
    var ThisWeekStepCounts = 0
    var ThisMonthStepCounts = 0
    var last30DaysStepCount = false
    var didHealthKitAlert = false

    
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
    var didLocationAlert = false
    
    //  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var currentStepCountLabel: UILabel!
    var userImage = Manbo.manbo00
    //userDefaults
    
    
    let userDefaults = UserDefaults.standard
    
    var stepGoal = UserDefaults.standard.stepsGoal!
    
    var firstGoal = UserDefaults.standard.stepsGoal!
    
    var stepPercent = UserDefaults.standard.stepPercent! {
        didSet {
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(named: self.userImage.rawValue)
            }
        }
    }
    var currentStepCount = UserDefaults.standard.currentStepCount! {
        didSet{
            DispatchQueue.main.async {
                self.currentStepCountLabel.text = self.currentStepCount.numberFormat()
                self.setUserImage()
                
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !userDefaults.isUpdate {
            self.makeAlertWithoutCancel(message: AlertText.updateMessage.rawValue, okTitle: AlertMenuText.ok.rawValue) {_ in
                self.userDefaults.isUpdate = true
            }
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       //   UserDefaults.standard.hasOnboarded = false
//        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        // 마지막 접속 날짜 받아오기
        getLastConnection()

        
        
        
        // MARK: - 헬스킷!
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            self.notiBanner(notiText: MainText.iphoneOnly.rawValue)
        }
        
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        dateFormatter.basicDateSetting()
        
        locationManager.delegate = self
        checkUserLocationServicesAuthorization()
        
        if !locationAuthorization && !didLocationAlert {
            locationSettingAlert()
            didLocationAlert = true
        }
        
        healthKItInform.text = MainText.requestHealthKit.rawValue
        
        healthKItInform.isHidden = true
        
        setUI()
        setUserImage()
        
        
        // MARK: - NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(changeGoalNotification), name:.goalNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeResetTimeNotification), name:.stepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStepCountNotification), name: .updateStepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noHealthKitAuthorizationNotification), name: .ifNoHealthKitAuthorization, object: nil)
        
        // MARK: - Firebase Analytics
        Analytics.logEvent("getUserSetting", parameters: [
            "name": userDefaults.name! as NSObject,
            "goal": userDefaults.stepsGoal! as NSObject,
            "resetTime": userDefaults.resetTime! as NSObject,
        ])
        
        
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }//: viewDidLoad
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
        
        healthStore?.authorizedHealthKIt()

    }//: viewWillAppear
    
    @objc func noHealthKitAuthorizationNotification(notification: NSNotification) {
        self.currentStepCountLabel.text = MainText.defaultMessage.rawValue
        self.healthKItInform.isHidden = false
    }
    
    @objc func changeStepCountNotification(notification: NSNotification) {
        if let newCount = notification.userInfo?["newCurrentStepCount"] as? Int {
            if userDefaults.healthKitAuthorization {
                currentStepCount = newCount
            //currentStepCountLabel.text = "\(currentStepCount.numberForamt())"
                healthKItInform.isHidden = true
             //   view.layoutIfNeeded()
            }
            else {
                currentStepCountLabel.text = MainText.defaultMessage.rawValue
                healthKItInform.isHidden = false

            }
        }
    }
    
    // calendar에서는 보이도록
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.isNavigationBarHidden = false
        
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(userDefaults.stepsGoal!.numberFormat())"
    }//: viewWillAppear
    
    @objc func changeGoalNotification(notification: NSNotification) {
        
        if let newGoal = notification.userInfo?["myValue"] as? Int {
            goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(newGoal.numberFormat())"
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
    
    @objc func changeResetTimeNotification(notification: NSNotification) {
        if let currentStep = notification.userInfo?["newStep"] as? Int {
            currentStepCountLabel.text = "\(currentStep.numberFormat())"
            setUserImage()
        }
    }
    
    func getLastConnection() {
        print("마지막접속일: \(userDefaults.lastConnection)")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        print("main: ", #function)
        goalView.maskedCornerRounded(cornerRadius: 10, maskedCorners:[ .layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(stepGoal.numberFormat())"
        let stepText = userDefaults.currentStepCount!.numberFormat()
        currentStepCountLabel.text = "\(String(describing: stepText))"
    }
    
    func setUserImage() {
        stepPercent = userDefaults.stepPercent!
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImageNotification"), object: nil, userInfo: ["ImageName": userImage.rawValue])
    }
    
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: CustomSideMenuNavigationViewController.identifier) as? CustomSideMenuNavigationViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
        
    }
    
    func notiBanner(notiText: String) {
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
    func fetchWeather() {
        OpenWeatherAPIManager.shared.fetchWeatherInformation(latitude: latitude, longitude: longitude) { temp  in
            
            
            let currentTemp = Int(temp)
            self.weatherTempLabel.text = "\(currentTemp)°C"
            
            
        }
    }
    func locationSettingAlert() {
        showAlert(title: AlertText.noLocationTitle.rawValue, message: AlertText.noLocationMessage.rawValue, okTitle: AlertMenuText.permit.rawValue) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url) { success in
                    }
                }
                
            }
        } //: locationSettingAlert
    func healthKitSettingAlert() {
        showAlert(title: AlertText.noHealthKitTitle.rawValue, message: AlertText.noHealthKitMessage.rawValue, okTitle: AlertMenuText.ok.rawValue) {
            self.healthStore?.authorizedHealthKIt()
//            self.didHealthKitAlert = true
//            guard let url = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//            if UIApplication.shared.canOpenURL(url){
//                UIApplication.shared.open(url) { success in
//                }
//            }
            
        }
        }
    }
    
//     MARK: - getToalStepCounts -> HealthKit Extension



// MARK: - LOCATION
extension ViewController: CLLocationManagerDelegate {
    
    func checkUserLocationServicesAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
    
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            fetchWeather()
            print("iOS 위치 서비스를 켜주세요 alert")
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("메인: ", #function)
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            setDefaultLocation()
        default:
            setDefaultLocation()
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
            fetchWeather()
        case .authorizedAlways:
            locationAuthorization = true
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationAuthorization = true
        case .authorized:
            fetchWeather()
        @unknown default:
            fetchWeather()
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


