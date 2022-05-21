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
        loadWebPage(urlString)
        self.manboImage.isHidden = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            self.manboImage.isHidden = true
//
//        })
//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNetworking()
    }
    
    func loadWebPage(_ url:String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func checkNetworking() {
        if !NetworkMonitor.shared.isConnected {
            self.showToast(message: ToastMessage.networkError.rawValue)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
              self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
              }
            })
        }
    }
}



