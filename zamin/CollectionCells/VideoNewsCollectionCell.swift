//
//  VideoNewsCollectionCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/27/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class VideoNewsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    var model : SimpleNewsModel!{
        didSet{
            imageView.load(url: model.imageUrl)
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
