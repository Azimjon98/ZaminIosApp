//
//  MyProtocols.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/4/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

protocol MyWishListDelegate {
    func wished(model: SimpleNewsModel)

    func unwished(newsId: String)
    
}


