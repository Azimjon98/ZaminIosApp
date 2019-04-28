//
//  LastNewsCollectionCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/27/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class LastNewsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var model : SimpleNewsModel!{
        didSet{
            titleLabel.text = model.title
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
