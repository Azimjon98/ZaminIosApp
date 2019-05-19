//
//  TagsCollectionViewCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/11/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagButton: UIButton!
    
    //    @IBOutlet weak var titleLabel: UILabel!
    
    
    var model : TagModel!{
        didSet{
            //            titleLabel.text = model.tagName
            tagButton.setTitle(model.tagName, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagButton.layer.borderWidth = 1.0
        tagButton.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        tagButton.layer.cornerRadius = 18.0
        tagButton.clipsToBounds = true
        
//        self.maxWidth.constant = UIScreen.main.bounds.width - 7 * 2
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
//        print("clicked")
    }

}
