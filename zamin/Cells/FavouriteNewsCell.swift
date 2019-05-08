//
//  FavouriteNewsCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class FavouriteNewsCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var delegate: MyWishListDelegate?
    
    var index : Int!{
        didSet{
            indexLabel.text = (index > 10 ? "" : "0") + "\(index ?? 1)"
        }
    }
    
    var model : EntityFavouriteNewsModel!{
        didSet{
            titleLabel.attributedText = String.myTitleAttributedString(text: model.title)
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
            
            bookmarkButton.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
            bookmarkButton.tag = 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func bookmarkPressed(sender: UIButton){
        if sender.tag == 1{
            if model.isWished{
                delegate?.unwished(newsId: model.newsId)
            }
        }
    }
    

    
}
