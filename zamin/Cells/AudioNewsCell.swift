//
//  AudioNewsCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class AudioNewsCell: UITableViewCell {
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var model : SimpleNewsModel!{
        didSet{
            label.attributedText = String.myTitleAttributedString(text: model.title)
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
