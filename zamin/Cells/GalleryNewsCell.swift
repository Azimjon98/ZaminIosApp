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
    var model : SimpleNewsModel?
    
    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var thirdPhoto: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    @IBAction func bookmarkPressed(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateItem(m: SimpleNewsModel){
        self.model = m
        
        firstPhoto?.sd_setImage(with:URL(string: model!.imageUrl), completed: nil)
        titleLabel.text = model!.title
        dateLabel.text = String.parseMyDate(date: model!.date)
        categoryLabel.text = String.parseMyCategoryName(id: model!.categoryId)
    }
    
}
