//
//  GalleryNewsCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryNewsCell: UITableViewCell {
    
    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var thirdPhoto: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var delegate : MyWishListDelegate?
    
    var model : SimpleNewsModel!{
        didSet{
            firstPhoto.load(url: model.galleryImages[0] ?? "", withQuality: .medium)
            secondPhoto.load(url: model.galleryImages[1] ?? "", withQuality: .small)
            thirdPhoto.load(url: model.galleryImages[2] ?? "", withQuality: .small)
            titleLabel.attributedText = String.myTitleAttributedString(text: model.title)
            dateLabel.text = String.parseMyDate(date: model.date)
            categoryLabel.text = model.categoryName
            bookmarkButton.setImage(
                model.isWished ? UIImage(named: "bookmark_active") : UIImage(named: "bookmark_inactive")
                , for: .normal)
            
            //            print("before Pressed")
            bookmarkButton.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
            bookmarkButton.tag = 1
            
        }
    }
    
    func bookItem(){
        model.isWished = true
        bookmarkButton.setImage( UIImage(named: "bookmark_active"), for: .normal)
    }
    
    func unbookItem(){
        model.isWished = false
        bookmarkButton.setImage( UIImage(named: "bookmark_inactive"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    @objc func bookmarkPressed(sender: UIButton!){
        
        if  sender.tag == 1{
            model.isWished = !model.isWished
            if model.isWished{
                delegate?.wished(model: model)
                bookmarkButton.setImage(UIImage(named: "bookmark_active"), for: .normal)
                
            } else{
                delegate?.unwished(newsId: model.newsId)
                bookmarkButton.setImage(UIImage(named: "bookmark_inactive"), for: .normal)
                
            }
            
        }
    }
    
}
