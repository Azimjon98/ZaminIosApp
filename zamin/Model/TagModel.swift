//
//  TagModel.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/2/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import SwiftyJSON

class TagModel{
    var tagName: String = ""
    
}

extension TagModel {
    
    static func parse(_ json: JSON) -> TagModel{
        let model = TagModel()
        if let tag = json["tag"].string {model.tagName = tag}
        
        return model
    }
    
    static func parse(_ json: JSON) -> [TagModel]{
        var tagItems : [TagModel] = [TagModel]()
        
        for tagItem in json.arrayValue{
            tagItems.append(TagModel.parse(tagItem))
        }
        
        return tagItems
    }
    
}
