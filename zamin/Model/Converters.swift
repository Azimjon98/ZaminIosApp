//
//  Converters.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/6/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

extension EntityFavouriteNewsModel{
    
    func convertToSimple() -> SimpleNewsModel{
        let model = SimpleNewsModel()
        
        model.title = self.title
        model.newsId = self.newsId
        model.categoryId = self.categoryId
        model.categoryName = self.categoryName
        model.date = self.date
        model.imageUrl = self.imageUrl
        model.originalUrl = self.originalUrl
        model.isWished = self.isWished
        
        
        return model
    }
}


extension SimpleNewsModel{
    
    func convertToFavourites() -> EntityFavouriteNewsModel{
        let model = EntityFavouriteNewsModel()
        
        model.title = self.title
        model.newsId = self.newsId
        model.categoryId = self.categoryId
        model.categoryName = self.categoryName
        model.date = self.date
        model.imageUrl = self.imageUrl
        model.originalUrl = self.originalUrl
        model.isWished = self.isWished
        
        
        return model
    }
}


extension ContentNewsModel{
    
    func convertToFavourites() -> EntityFavouriteNewsModel{
        let model = EntityFavouriteNewsModel()
        
        model.title = self.title
        model.newsId = self.newsId
        model.categoryId = self.categoryId
        model.categoryName = self.categoryName
        model.date = self.date
        model.imageUrl = self.imageUrl
        model.originalUrl = self.originalUrl
        model.isWished = self.isWished
        
        
        return model
    }
}
