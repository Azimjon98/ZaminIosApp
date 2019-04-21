//
//  ContentNewsModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

class ContentNewsModel{
    public var newsId: String;
    public var title: String;
    public var imageUrl: String;
    public var originalUrl: String;
    public var categoryId: String;
    public var categoryName: String;
    public var date: String;
    public var viewedCount: String;
    public var isWished : Bool;
    public var contentUrl : String;
    
    init(newsId: String, title: String, imageUrl: String, originalUrl: String, categoryId: String, categoryName: String, date: String, viewedCount: String, contentUrl: String) {
        self.newsId = newsId
        self.title = title
        self.imageUrl = imageUrl
        self.originalUrl = originalUrl
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.date = date
        self.viewedCount = viewedCount
        self.contentUrl = contentUrl
        
        isWished = false
    }
    
    init(newsId: String, title: String, imageUrl: String, originalUrl: String, categoryId: String, categoryName: String, date: String, viewedCount: String,contentUrl: String, isWished: Bool) {
        self.newsId = newsId
        self.title = title
        self.imageUrl = imageUrl
        self.originalUrl = originalUrl
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.date = date
        self.viewedCount = viewedCount
        self.contentUrl = contentUrl
        
        self.isWished = isWished
    }
}
