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
    
    @IBOutlet weak var viewedCountLabel: UILabel!
    @IBOutlet weak var viewedIcon: UIImageView!
    
    
    var model : ContentNewsModel!{
        didSet{
            
            titleLabel.text = model.title
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
            viewedCountLabel.text = model.viewedCount
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewedIcon.changeColor (color: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1))
        // Initialization code
       
    }
    
   

    
}


class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
