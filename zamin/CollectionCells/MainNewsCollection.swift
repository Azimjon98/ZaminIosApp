//
//  MainNewsCollection.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/25/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class MainNewsCollection: UICollectionView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isPagingEnabled = true
        self.register(UINib(nibName: "MainNewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "mainNewsCollectionCell")
    }
    
}
