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
        
        // MARK: - 헬스킷!
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            self.notiBanenr(notiText: "만보랑은 아이폰에서 사용이 가능합니다🐾")
        }
        
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        dateFormatter.basicDateSetting()
        
        locationManager.delegate = self
        checkUserLoactionServicesAuthorization()
        
        if !locationAuthorization && !didLocationAlert {
            locationSettingAlert()
            didLocationAlert = true
        }
       
        
        setUI()
        setUserImage()
        SetNotiViewController().requestNotificationAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeGoalNotification), name:.goalNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeResteTimeNotification), name:.stepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStepCountNotification), name: .updateStepNotification, object: nil)
        
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }//: viewDidLoad
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("main",#function)

        self.navigationController?.isNavigationBarHidden = true
        
        healthStore!.authorizedHealthKIt()
        if !userDefaults.healthKitAuthorization, !didHealthKitAlert {
            currentStepCountLabel.text = "만보랑 같이 걸어요"
            healthKitSettingAlert()
        }
//
    }//: viewWillAppear
    
    @objc func changeStepCountNotification(notification: NSNotification) {
        if let newCount = notification.userInfo?["newCurrentStepCount"] as? Int {
            if newCount == 0 {
                currentStepCountLabel.text = "만보랑 같이 걸어요"
            } else {
            currentStepCountLabel.text = "\(newCount.numberForamt())"
                view.layoutIfNeeded()
            }
        }
    }
    
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
    
    
    func fetchWeather() {
        OpenWeatherAPIManager.shared.fetchWeatherInformation(latitude: latitude, longitude: longitude) { temp  in
            
            
            let currentTemp = Int(temp)
            self.weatherTempLabel.text = "\(currentTemp)°C"
            
            
        }
    }
    func locationSettingAlert() {
            showAlert(title: "위치 서비스를 사용할 수 없습니다.", message: "지도에서 내 위치를 확인하여 정확한 날씨 정보를 얻기 위해 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", okTitle: "허용하기") {
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
        showAlert(title: "걸음을 가져올 수 없습니다.", message: "건강 앱에서 내 걸음수를 읽을 수 있도록 '건강 > 걸음 > 데이터 소스 및 접근'에서 만보랑의 읽기 접근을 허용해 주세요.", okTitle: "확인") {
            self.healthStore!.authorizedHealthKIt()
            self.didHealthKitAlert = true
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
            fetchWeather()
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
            fetchWeather()
            print("설정으로")
        case .authorizedAlways:
            locationAuthorization = true
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationAuthorization = true
        case .authorized:
            print("default")
            fetchWeather()
        @unknown default:
            print("default")
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


