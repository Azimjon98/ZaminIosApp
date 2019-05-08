//
//  ContentHeaderTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/30/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SVProgressHUD


class ContentHeaderTableCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var viewedCountLabel: UILabel!
    @IBOutlet weak var viewedIcon: UIImageView!
    
    
    var model : ContentNewsModel!{
        didSet{
            
            titleLabel.text = model.title
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
            viewedCountLabel.text = model.viewedCount
            baseImageView.load(url: model.imageUrl, withFixedSide: true)
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewedIcon.changeColor (color: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1))
        // Initialization code
       
    }
    
   

    
}


