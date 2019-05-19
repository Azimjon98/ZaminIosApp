//
//  EntityFavouriteNewsModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/30/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class EntityFavouriteNewsModel: Object{
    
    @objc dynamic var newsId: String = "";
    @objc dynamic var title: String = "";
    @objc dynamic var imageUrl: String = "";
    @objc dynamic var originalUrl: String = "";
    @objc dynamic var categoryId: String = "";
    @objc dynamic var categoryName: String = "";
    @objc dynamic var date: String = "";
    @objc dynamic var isWished : Bool = false;
    
    @objc dynamic var lastLocale = "uz";
}


extension EntityFavouriteNewsModel{
    
    static func parse(fromSimpleNewsModel m: SimpleNewsModel) -> EntityFavouriteNewsModel{
        let model = EntityFavouriteNewsModel()
        
        model.newsId = m.newsId
        model.title = m.title
        model.imageUrl = m.imageUrl
        model.originalUrl = m.originalUrl
        model.categoryId = m.categoryId
        model.categoryName = m.categoryName
        model.date = m.date
        model.isWished = m.isWished
        model.lastLocale = UserDefaults.getLocale()
        
        return model
    }
    
    func update(json: JSON){

        if let title = json["title"].string{ self.title = title }
        self.lastLocale = UserDefaults.getLocale()
        
        let categories: Results<EntityCategoryModel> = (try! Realm()).objects(EntityCategoryModel.self)
        for i in categories{
            if i.categoryId == self.categoryId{
                self.categoryName = i.name
                break
            }
        }
        
    }
    
    
    
    
}
