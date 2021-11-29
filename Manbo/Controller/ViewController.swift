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


class ViewController: UIViewController {
    static let identifier = "ViewController"
    // MARK: - PROPERTIES
    
    // healthStore
    var healthKitAuthorization = false
    var healthStore: HKHealthStore?
    var totalStepCount = 0.0
    var SevenDaysStepCounts = 0
    var ThisWeekStepCounts = 0
    var ThisMonthStepCounts = 0
    
    //time
    var today = Date()
    let dateFormatter = DateObject.dateFormatter
    let calendar = DateObject.calendar
    
    //Realm
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    
    //CoreLocation
    let locationManager = CLLocationManager()
    var locationAuthorization = false
    
    
    //  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var currentStepCountLabel: UILabel!
    var userImage = Manbo.manbo00
    
    //userDefaults
    let userDafaults = UserDefaults.standard
    
    var stepGoal = UserDefaults.standard.stepsGoal!
    var stepPercent = UserDefaults.standard.setpPercent! {
        didSet {
            //print("퍼센테이지 바꼈다.")
            DispatchQueue.main.async {
                self.setUserImage()
            }
        }
    }
    var currentStepCount = UserDefaults.standard.currentStepCount! {
        didSet{
            //print("걸음수값 변경되었다.")
            DispatchQueue.main.async {
                self.currentStepCountLabel.text = "\(self.currentStepCount)"
            }
        }
    }
    //
    
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
      //  UserDefaults.standard.hasOnbarded = false
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        dateFormatter.basicDateSetting()
        
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            //healthKit은 아이패드 등에서는 안돼요.
        }
       
        setUI()
        // scrollView.addSubview(self.refreshControl)
        
    }//: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("main",#function)
        self.navigationController?.isNavigationBarHidden = true
        
        if healthStore != nil {
            if healthStore!.ishealthKitAuthorized() {
                 self.getTodayStepCounts()
//                healthStore?.getSevenDaysStepCounts()
                healthStore?.getThisWeekStepCounts()
                healthStore?.getThisMonthStepCounts()
            } else {
                healthStore!.authorizeHealthKit()
            }
        }

        setUserImage()
 
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
        goalLabel.text = "\(LocalizableStrings.goal_steps.LocalizedMain) \(String(stepGoal))"
    }
    
    func setUserImage() {
        print("main: percente \(stepPercent)", #function)
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
    
    func setDefaultLocation() {
        let lat = 37.566403559824955
        let lon = 126.97794018074802
        print("기본 주소: \(lat), \(lon)")
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
    
  
}
    
//     MARK: - getToalStepCounts -> HealthKit Extension
    


//    func locationSettingAlert() {
//        showAlert(title: "위치 서비스를 사용할 수 없습니다.", message: "지도에서 내 위치를 확인하여 정보를 얻기 위해 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", okTitle: "설정으로 이동") {
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



// MARK: - LOCATION
extension ViewController: CLLocationManagerDelegate {
    
    //3. 앱 처음 실행했거나, 권한을 변경하고자 할때
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
    
    // 1. 사용자가 위치를 허용했다면
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("메인: ", #function)
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("\(lat), \(lon)")
            
        } else {
            let lat = 37.566403559824955
            let lon = 126.97794018074802
            print("기본 주소: \(lat), \(lon)")
        }
    }
    // 2. 허용했는데, 에러남
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
            print("dlfault")
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
//
//extension ViewController: MTMapViewDelegate() {
//    func mapVe
//}

////처음 실행하는 경우, 권한이 변경된 경우
//func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    print(#function)
//    //check
//}
//func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    print(#function)
//    //check
//}
//




//extension Date {
//    static func mondayAt12AM() -> Date {
//        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))!
//    }
//}

