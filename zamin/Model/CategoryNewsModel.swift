//
//  CategoryNewsModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

class CategoryNewsModel: Decodable{
    public var name: String = "";
    public var categoryId : String;
    public var imageUrl : String;
    public var isEnabled : Bool;
    
    init(name: String, categoryId: String, imageUrl: String) {
        self.name = name
        self.categoryId = categoryId
        self.imageUrl = imageUrl
        isEnabled = false
    }
    
    init(name: String, categoryId: String, imageUrl: String, isEnabled: Bool) {
        self.name = name
        self.categoryId = categoryId
        self.imageUrl = imageUrl
        self.isEnabled = isEnabled
    }
    
}
