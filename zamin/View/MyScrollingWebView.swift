//
//  MyScrollingWebView.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/7/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

import WebKit

class MyScrollingWebView : WKWebView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = false
        
    }
    
}
