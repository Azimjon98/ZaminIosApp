//
//  MyWebView.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/3/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import WebKit

class MyUnScrollingWebView : WKWebView, UIScrollViewDelegate{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.isScrollEnabled = false
        self.scrollView.isPagingEnabled = false
        self.scrollView.delegate = self
        }
    
    
   
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

