//
//  SimpleNewsCategory.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class SimpleNewsModel{
    
    let realm = try! Realm()
    
    public var newsId: String = "";
    public var title: String = "";
    public var imageUrl: String = "";
    public var originalUrl: String = "";
    public var categoryId: String = "";
    public var categoryName: String = "";
    public var date: String = "";
    public var isWished : Bool = false;
    
    public var galleryImages: [String?] = [String?]()
    public var audioUrl = "";
    
    

}


extension SimpleNewsModel{
    
    static func parse(json: JSON, type: Int = -1, withCategory state: Bool = false) -> SimpleNewsModel{
        
        
        let model = SimpleNewsModel()
        
        if let newsId = json["newsID"].string{ model.newsId = newsId }
        if let title = json["title"].string{ model.title = title }
        if let date = json["publishedAt"].string{ model.date = date }
        if let categoryId = json["categoryID"].string{ model.categoryId = categoryId }
        if let originalUrl = json["url"].string{ model.originalUrl = originalUrl }
        if let imageUrl = json["urlToImage"].string{ model.imageUrl = imageUrl }
        
        if type == 1 {
            model.galleryImages.append(model.imageUrl)
            if let image2 = json["urlToImage2"].string{ model.galleryImages.append(image2)}
            if let image3 = json["urlToImage3"].string{ model.galleryImages.append(image3)}
        }
        
        else if type == 3{
            
        }
        
        if  state{
            let categories: Results<EntityCategoryModel> = (try! Realm()).objects(EntityCategoryModel.self)
            for i in categories{
                if i.categoryId == model.categoryId{
                    model.categoryName = i.name
                    break
                }
            }
        }
        return model
    }
    
    static func parse(json: JSON, type: Int = -1) -> [SimpleNewsModel]?{
        let categories: Results<EntityCategoryModel> = (try! Realm()).objects(EntityCategoryModel.self)
        
        var items = [SimpleNewsModel]()
        if let _ = json["articles"].array{
            
        }else{
            return nil
        }
        
        for newsItem in json["articles"].arrayValue{
            let model: SimpleNewsModel = SimpleNewsModel.parse(json: newsItem, type: type)
            for i in categories{
                if i.categoryId == model.categoryId{
                    model.categoryName = i.name
                    break
                }
            }
            
            items.append(model)
        }
    
        
        return items
    }
    
}
