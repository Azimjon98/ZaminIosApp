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
    func contentDidLoad(_ height: CGFloat)
    func contentAction(linkUrl url: String)
}

class ContentWebViewTableCell: UITableViewCell, WKNavigationDelegate, WKUIDelegate{
    @IBOutlet weak var webView : MyUnScrollingWebView!
    @IBOutlet weak var constrainWebView : NSLayoutConstraint!
    
    var heightStack: [CGFloat] = []
    
    
    var contentUrl: String!{
        didSet{
            print("before load:" + contentUrl)
            
//            let myUrl = URL(string: "http://kun.uz")
            let myUrl = URL(string: contentUrl)
            var myRequest = URLRequest(url: myUrl!)
            myRequest.cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
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
    
    func updateWebView(_ increasing: Bool){
        print("heightStack")
        for i in heightStack{
            print(i)
        }
        
        if increasing{
            self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        
                        self.constrainWebView.constant = height as? CGFloat ?? 0.0
                        self.heightStack.append(height as? CGFloat ?? 0.0)
                        print("WebViewIncrease: \(self.constrainWebView.constant)   \(self.webView.scrollView.contentSize.height)")
                        self.delegate.contentDidLoad(self.constrainWebView.constant)
                    })
                }
                
            })
        }
        
        else{
            _ = self.heightStack.popLast()
            self.constrainWebView.constant =  self.heightStack.last ?? 0.0
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                print("WebViewDecrease: \(self.constrainWebView.constant)   \(self.webView.scrollView.contentSize.height)")
                self.delegate.contentDidLoad(self.constrainWebView.constant)
            }
            
        }
    }
    
    //content finish loading web content
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish")
        
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    //save all heights for resizing webView
                    self.heightStack.append(self.webView.scrollView.contentSize.height)
                    self.constrainWebView.constant = self.webView.scrollView.contentSize.height
                    self.saveStates(size: 100)
                })
            }
            
        })
        
    }
    
    func saveStates(size: Int){
        if size == UserDefaults.getFontSize(){
            self.delegate.contentDidLoad(self.constrainWebView.constant)
            return
        }
        
        self.webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(size + 10)%'") { (complete, error) in
            self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        self.heightStack.append(height as? CGFloat ?? 0.0)
                        self.constrainWebView.constant = height as? CGFloat ?? 0.0
                        self.saveStates(size: size + 10)
                    })
                }
                
            })
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

