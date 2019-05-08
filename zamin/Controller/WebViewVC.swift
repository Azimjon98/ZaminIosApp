//
//  WebViewVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/2/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewVC: UIViewController,WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: MyScrollingWebView!
    var contentUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialization code
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        let myUrl = URL(string: contentUrl ?? "http://m.zamin.uz/api/v1/articleParser.php?lang=oz&id=53765")
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
    

   
    
    //content starting loading in vewview
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start 2")
        SVProgressHUD.show()
    }
    
    
    //content finish loading web content
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish")
        SVProgressHUD.dismiss()
        
    }
    
}
