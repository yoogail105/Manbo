//
//  ChatViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/12/02.
//

import UIKit
import WebKit

class ChatViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
        
        @IBOutlet weak var manboImage: UIImageView!
        @IBOutlet weak var webView: WKWebView!

        static let identifier = "ChatViewController"
        
        var urlString = "https://hmhhsh.notion.site/59521b608ee8440a98dd069edea5e9f4"
        
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
}
