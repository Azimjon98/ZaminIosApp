//
//  LastNewsCollection.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/27/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class LastNewsCollection: UICollectionView{
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        register(UINib(nibName: "LastNewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "lastNewsCollectionCell")
    }
    

}
