//
//  VideoNewsCollection.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/27/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class VideoNewsCollection: UICollectionView{

    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(UINib(nibName: "VideoNewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "videoNewsCollectionCell")
    }

}
