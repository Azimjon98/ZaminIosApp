//
//  ApiHelper.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/26/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import Alamofire

class ApiHelper{
    static func getAllCategories() -> [String: String]{
        return
            [
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
            ]
        
    }
    
    static func getLastNews(offset: Int, limit: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
            ]
        
    }
    
    static func getMainNews() -> [String: String]{
        return
            [
                "offset" : "1",
                "limit": "10",
                "main": "1",
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
        
    }
    
    static func getTopNews(offset: Int, limit: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "popular" : "1",
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
        
    }
    
    static func getContentWithId(id: Int) -> [String: String]{
        return
            [
                "id" : "\(id)",
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
    }
    
    static func getContentTags(id: Int) -> [String: String]{
        return
            [
                "id" : "\(id)",
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
    }
    
    static func getNewsWithCategory(offset: Int, limit: String, categoryId: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "category" : categoryId,
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
        
    }
    
    static func getNewsWithTags(offset: Int, limit: String, tagName: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "tagname" : tagName,
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
        
    }
    
    static func searchNewsWithTitle(offset: Int, limit: String, key: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "key" : key,
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
    }
    
    static func getMediaNewsWithType(offset: Int, limit: String, type: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "type" : type,
                "lang": UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        ]
    }
    
}
