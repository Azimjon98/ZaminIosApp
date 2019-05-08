//
//  TagCollectionCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/2/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class TagCollectionCell: UICollectionViewCell {
    @IBOutlet weak var tagNameLabel: UILabel!
    
    var model : TagModel!{
        didSet{
            tagNameLabel.text = model.tagName
        }
    }
    
    
}
