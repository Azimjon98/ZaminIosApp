//
//  SimpleNewsCategory.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import SwiftyJSON

class SimpleNewsModel{
    
    public var newsId: String = "";
    public var title: String = "";
    public var imageUrl: String = "";
    public var originalUrl: String = "";
    public var categoryId: String = "";
    public var categoryName: String = "";
    public var date: String = "";
    public var viewedCount: String = "";
    public var isWished : Bool = false;
    
    public var galleryImages: [String] = [String]()
    public var audioUrl = "";
    
    init(){}
    
    init(json: JSON, isMedia: Bool, type: Int = 12) {
        if let newsId = json["newsID"].string{ self.newsId = newsId }
        if let title = json["title"].string{ self.title = title }
        if let date = json["publishedAt"].string{ self.date = date }
        if let categoryId = json["categoryID"].string{ self.categoryId = categoryId }
        if let originalUrl = json["url"].string{ self.originalUrl = originalUrl }
        if let imageUrl = json["urlToImage"].string{ self.imageUrl = imageUrl }
        if let viewedCount = json["viewed"].string{ self.viewedCount = viewedCount }
        
    }

    func asd(sd df: String){
        
    }
}
