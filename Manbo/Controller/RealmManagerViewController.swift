//
//  RealmManagerViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit
import RealmSwift

extension Realm {
    
}

class RealmManagerViewController: UIViewController {

    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
//        pin = tasks.filter("pin == true").sorted(byKeyPath: "writeDate", ascending: false)
        
    }
    
    //  if tasks.filter("date == true").count == 0 {
      //    print("ok")
          
//          try! realm.write {
//              realm.add(task)
//              print("add success")
//          }
//                        } else if savedDate == todayReport {
//                            //업데이트
////                            try! realm.write {
//                               // filterdTask?.first?.stepCount = Int(dayCount)
//                                //filterdTask?.first?.goalPercent = dayCount / Double(goal)
////                            }
//                            print("update success")
//                        }


}

