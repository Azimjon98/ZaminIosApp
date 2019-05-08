//
//  EntityCategoryModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/1/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class EntityCategoryModel: Object{
    @objc dynamic var name: String = "";
    @objc dynamic var categoryId : String = "-1";
    @objc dynamic var imageUrl : String = "";
    @objc dynamic var isEnabled : Bool = true;
    
    
}

extension EntityCategoryModel{
    
    static func parse(json: JSON) -> EntityCategoryModel{
        let model = EntityCategoryModel()
        
        if let categoryId = json["id"].string{ model.categoryId = categoryId }
        if let name = json["name"].string{ model.name = name }
        
        return model
    }
    
    
    
}
