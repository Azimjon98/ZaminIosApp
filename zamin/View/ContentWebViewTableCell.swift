//
//  ContentWebViewTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/3/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import WebKit

protocol ContentLoadingDelegate{
    func contentDidLoad()
    func contentAction(linkUrl url: String)
}

class ContentWebViewTableCell: UITableViewCell, WKNavigationDelegate, WKUIDelegate{
    @IBOutlet weak var webView : MyUnScrollingWebView!
    @IBOutlet weak var constrainWebView : NSLayoutConstraint!
    
    var contentUrl: String!{
        didSet{
            print("before load:" + contentUrl)
            
//            let myUrl = URL(string: "http://kun.uz")
            let myUrl = URL(string: contentUrl)
            let myRequest = URLRequest(url: myUrl!)
            webView.load(myRequest)
        }
    }
    
    var delegate: ContentLoadingDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    //content finish loading web content
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let currentHeight = self.constrainWebView.constant
            if currentHeight != webView.scrollView.contentSize.height{
                
                webView.scrollView.maximumZoomScale = 1.0
                
                self.constrainWebView.constant = webView.scrollView.contentSize.height

                self.delegate.contentDidLoad()
            }
            
        }

    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let _ = navigationAction.request.url {
            let urlString:String = "\(navigationAction.request.url!)"
            if urlString.contains("https://zamin.uz/index.php?do=go"){
                decisionHandler(.cancel)
                delegate.contentAction(linkUrl: urlString)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    
}

