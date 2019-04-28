//
//  CategoriesCollection.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/25/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class CategoriesCollection: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
    }
    
    
 
  
    

}
