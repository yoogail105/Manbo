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

final class RealmManagerViewController: UIViewController {
    
    let localRealm = try! Realm()
    var tasks: Results<UserReport>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false)
        
    }
}

