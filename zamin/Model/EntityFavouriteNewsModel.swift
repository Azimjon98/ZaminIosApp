//
//  EntityFavouriteNewsModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/30/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import RealmSwift

class EntityFavouriteNewsModel: Object{
    
    @objc dynamic var newsId: String = "";
    @objc dynamic var title: String = "";
    @objc dynamic var imageUrl: String = "";
    @objc dynamic var originalUrl: String = "";
    @objc dynamic var categoryId: String = "";
    @objc dynamic var categoryName: String = "";
    @objc dynamic var date: String = "";
    @objc dynamic var isWished : Bool = false;
    
    
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
        
        return model
    }
    
}
