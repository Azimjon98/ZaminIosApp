//
//  ContentNewsModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ContentNewsModel{
    public var newsId: String = "";
    public var title: String = "";
    public var imageUrl: String = "";
    public var originalUrl: String = "";
    public var categoryId: String = "";
    public var categoryName: String = "";
    public var date: String = "";
    public var isWished : Bool = false;
    public var viewedCount : String = "1";
    public var contentUrl : String = "";
    
    
}

extension ContentNewsModel{
    
    static func parse(json: JSON) -> ContentNewsModel{
        let model = ContentNewsModel()
        
        if let newsId = json["newsID"].string{ model.newsId = newsId }
        if let title = json["title"].string{ model.title = title }
        if let date = json["publishedAt"].string{ model.date = date }
        if let categoryId = json["categoryID"].string{ model.categoryId = categoryId }
        if let originalUrl = json["url"].string{ model.originalUrl = originalUrl }
        if let imageUrl = json["urlToImage"].string{ model.imageUrl = imageUrl }
        if let viewedCount = json["viewed"].string{ model.viewedCount = viewedCount }
        if let contentUrl = json["urlparser"].string{ model.contentUrl = contentUrl }
        
        
        let categories: Results<EntityCategoryModel> = (try! Realm()).objects(EntityCategoryModel.self)
        for i in categories{
            if i.categoryId == model.categoryId{
                model.categoryName = i.name
                break
            }
        }
        return model
    }
    
}
