//
//  SettingViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit
import Zip
import MobileCoreServices
import RealmSwift

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    // Button
    @IBOutlet weak var resetNameButton: UIButton!
    @IBOutlet weak var resetGoalButton: UIButton!
    @IBOutlet weak var resetStepTimeButton: UIButton!
    @IBOutlet weak var resetNotiTimeButton: UIButton!
    @IBOutlet weak var resetColorButton: UIButton!
    @IBOutlet weak var turnOffAlarmButton: UIButton!
    
    @IBOutlet weak var stepGoalLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var resetTimeLabel: UILabel!
    @IBOutlet weak var notiTimeLabel: UILabel!
    
    
    
    let setMenuItem = ["백업하기","복구하기","공지사항", "문의하기", "개인정보정책", "버전"]
    
    let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    let fileManager = FileManager.default
    var today = ""
    var notiTime = UserDefaults.standard.notiTime {
        didSet {
        }
    }
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        today = dateFormatter.backupDateString(date: Date())
        tableView.delegate = self
        tableView.dataSource = self
        
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
        
        //       if notiTime == nil {
        //            self.turnOffAlarmButton.isHidden = true
        //       } else {
        //           self.turnOffAlarmButton.isHidden = false
        //       }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        
        setButtonsUI()
        
        notiTimeLabel.setTimeLabelUI()
        resetTimeLabel.setTimeLabelUI()
        stepGoalLabel.setTimeLabelUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SettingViewController", #function)
        
        //        if  userDefaults.notiTime == nil {
        //             self.turnOffAlarmButton.isHidden = true
        //        } else {
        //            self.turnOffAlarmButton.isHidden = false
        //        }
        
        print(userDefaults.name!, String(userDefaults.stepsGoal!), dateFormatter.simpleTimeString(date: userDefaults.resetTime!))
        
        if userDefaults.notiTime != nil {
            notiTimeLabel.text =  dateFormatter.simpleTimeString(date: userDefaults.notiTime!)
            notiTimeLabel.isHidden = false
            //turnOffAlarmButton.setTitle("끄기", for: .normal)
        } else {
            notiTimeLabel.isHidden = true
            //   turnOffAlarmButton.setTitle("없음", for: .normal)
            
        }
        userNameLabel.text = userDefaults.name!
        stepGoalLabel.text = "\(userDefaults.stepsGoal!.numberFormat()) 걸음"
        resetTimeLabel.text = dateFormatter.simpleTimeString(date: userDefaults.resetTime!)
        
        
    }
    
    func setButtonsUI() {
        resetNameButton.settingButtonUI(title: "수정")
        resetGoalButton.settingButtonUI(title: "수정")
        resetNotiTimeButton.settingButtonUI(title: "수정")
        resetStepTimeButton.settingButtonUI(title: "수정")
        turnOffAlarmButton.settingButtonUI(title: "끄기")
        //turnOffAlarmButton.setTitle("끄기", for: .normal)
    }
    
    
    @IBAction func resetNameButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetName", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNameViewController.identifier) as? SetNameViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func setpGoalButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetStepGoal", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetStepGoalViewController.identifier) as? SetStepGoalViewController else {
            print("Error")
            return
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func resetTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetResetTime", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: ResetTimeViewController.identifier) as? ResetTimeViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func resetNotiTimeButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SetNotiTime", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SetNotiViewController.identifier) as? SetNotiViewController else {
            print("Error")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func turnOffAlarmButtonClicked(_ sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey: "notiTime")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "turnOffNotification"), object: nil)
        notiTimeLabel.isHidden = true
        //  turnOffAlarmButton.isHidden = true
        //resetNotiTimeButton.setTitle("켜기", for: .normal)
        
    }
    
    
    
    func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let directoryPath = path.first {
            return directoryPath
        }else {
            return nil
        }
        
    }
    
    func presentActivityViewController() {
        print(#function)
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("\(self.today)My_Manborang.zip")
        
        let fileURL = URL(fileURLWithPath: fileName)
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    func backup() {
        //self.showToast(message: "백업을 시작합니다.\n 잠시만 기다려주세요")
        var urlPaths = [URL]()
        
        if let path = documentDirectoryPath() {
            
            let realm = (path as NSString).appendingPathComponent("default.realm")
            if FileManager.default.fileExists(atPath: realm) {
                urlPaths.append(URL(string: realm)!)
                print("압축했습니다.\(urlPaths)")
            }
            else {
                print("백업할 파일이 없습니다.")
            }
            
        }
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "\(today)My_Manborang")
            print("압축경로: \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
            print("Something went wrong")
        }
        
    }
    
    func restore() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
}//: ViewDidLoad


// MARK: - TABLEVIEW
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setMenuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingBasicTableViewCell.identifier, for: indexPath) as? SettingBasicTableViewCell else {
            return UITableViewCell() }
        cell.selectionStyle = .none
        let row = indexPath.row
        //String
        
        cell.menuLabel.text = setMenuItem[row]
        if setMenuItem[row] == "버전" {
            cell.rightLabel.text = "1.1.3"
            cell.rightLabel.font = UIFont.italicSystemFont(ofSize: 10)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 공지사항은 다른 테이블뷰로 이동
        // 이용약관, 개인보호정책, 오픈소스, 버전은 문자열 표시
        
        let cellURL = ["https://hmhhsh.notion.site/ab8d1336219d4a36a3b0b43adaa603b3",
                       "https://hmhhsh.notion.site/f2f120f85fdf4bfcb9e52db44ef7b6f1",
                       "https://hmhhsh.notion.site/19e03d2d23c248978f0f664c60f333bb"]
        
        let row = indexPath.row
        
        if row == 0 {
            self.backup()
        } else if row == 1 {
            self.restore()
        } else if setMenuItem[row] != "버전" {
            let sb = UIStoryboard(name: "SettingText", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: SettingTextViewController.identifier) as? SettingTextViewController else { return }
            vc.urlString = cellURL[row - 2]
            present(vc, animated: true, completion: nil)
        }
    }
    
    
}

extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function)

        guard let selectedFileURL = urls.first else { return }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
    
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("\(today)My_Manborang.zip")
                try Zip.unzipFile(fileURL,
                                  destination: documentDirectory,
                                  overwrite: true,
                                  password: nil,
                                  progress: { progress in
                                       print("progress: \(progress)")
                    self.showToast(message: "복구가 완료되었습니다.\n안전한 사용을 위해 만보랑을 다시 시작해 주세요.")
                                  },
                                  fileOutputHandler: { unzippedFile in
                                       print("unzippedFile: \(unzippedFile)")
                                  })
            } catch {
                print("압축해제 에러!")
            }
        } else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("\(today)My_Manborang.zip")
                try Zip.unzipFile(fileURL,
                                  destination: documentDirectory,
                                  overwrite: true,
                                  password: nil,
                                  progress: { progress in
                                       print("progress: \(progress)")
                    self.showToast(message: "복구가 완료되었습니다.\n안전한 사용을 위해 만보랑을 다시 시작해 주세요.")
                                  },
                                  fileOutputHandler: { unzippedFile in
                                       print("unzippedFile: \(unzippedFile)")
                                  })
            } catch {
                print("압축해제 에러!")
            }
        }
    }
}
