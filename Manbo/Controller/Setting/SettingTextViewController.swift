//
//  SettingTextViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/29.
//

import UIKit
import WebKit

class SettingTextViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var manboImage: UIImageView!
    @IBOutlet weak var webView: WKWebView!

    static let identifier = "SettingTextViewController"
    
    var urlString = "https://hmhhsh.notion.site/f2f120f85fdf4bfcb9e52db44ef7b6f1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.manboImage.isHidden = true
        
        })
        loadWebPage(urlString)
    }
        
        
        
//        let request = URLRequest(url: url!)
//        self.webView?.allowsBackForwardNavigationGestures = true

    
    func loadWebPage(_ url:String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
        
    @IBAction func onBtnBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    
    }

