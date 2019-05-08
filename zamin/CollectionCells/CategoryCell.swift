//
//  CategoryCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/25/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var model : EntityCategoryModel!{
        didSet{
            titleLabel.text = model.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentvi
        // Initialization code
    }

}
