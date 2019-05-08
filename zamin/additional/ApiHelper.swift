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
    static func getAllCategories(_ lang: String = LanguageHelper.apiLang()) -> [String: String]{
        return
            [
                "lang": lang
            ]
        
    }
    
    static func getLastNews(offset: Int, limit: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "lang": LanguageHelper.apiLang()
            ]
        
    }
    
    static func getMainNews() -> [String: String]{
        return
            [
                "offset" : "1",
                "limit": "10",
                "main": "1",
                "lang": LanguageHelper.apiLang()
        ]
        
    }
    
    static func getTopNews(offset: Int, limit: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "popular" : "1",
                "lang": LanguageHelper.apiLang()
        ]
        
    }
    
    static func getContentWithId(id: String) -> [String: String]{
        return
            [
                "id" : id,
                "lang": LanguageHelper.apiLang()
        ]
    }
    
    static func getContentInside(id: String) -> [String: String]{
        return
            [
                "id" : id,
                "lang": LanguageHelper.apiLang()
        ]
    }
    
    static func getContentTags(id: String) -> [String: String]{
        return
            [
                "id" : id,
                "lang": LanguageHelper.apiLang()
        ]
    }
    
    static func getNewsWithCategory(offset: Int, limit: String, categoryId: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "category" : categoryId,
                "lang": LanguageHelper.apiLang()
        ]
        
    }
    
    static func getNewsWithTags(offset: Int, limit: String, tagName: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "tagname" : tagName,
                "lang": LanguageHelper.apiLang()
        ]
        
    }
    
    static func searchNewsWithTitle(offset: Int, limit: String, key: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "key" : key,
                "lang": LanguageHelper.apiLang()
        ]
    }
    
    static func getMediaNewsWithType(offset: Int, limit: String, type: String) -> [String: String]{
        return
            [
                "offset" : "\(offset)",
                "limit": limit,
                "type" : type,
                "lang": LanguageHelper.apiLang()
        ]
    }
    
}
