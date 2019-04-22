//
//  GalleryNewsCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class GalleryNewsCell: UITableViewCell {

    @IBOutlet weak var photoSet: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        photoSet.layer.cornerRadius = 6
        photoSet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
