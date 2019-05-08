//
//  Constants.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/25/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

class Constants {
    public static let BASE_URL : String = "http://m.zamin.uz/api/v1/"
    
    public static let URL_TOP_NEWS : String = Constants.BASE_URL
    public static let URL_SEARCH_NEWS : String = Constants.BASE_URL + "search.php"
    public static let URL_CATEGORIES : String = Constants.BASE_URL + "category.php"
    public static let URL_CONTENT : String = Constants.BASE_URL + "article.php"
    public static let URL_CONTENT_INSIDE : String = Constants.BASE_URL + "articleParser.php"
    public static let URL_TAGS : String = Constants.BASE_URL + "tags.php"
    public static let URL_MEDIA_NEWS : String = Constants.BASE_URL + "media.php"
    
    
    
    
    //MARK: - KEYS
    public static let KEY_LANG : String = "key_lang"
}
