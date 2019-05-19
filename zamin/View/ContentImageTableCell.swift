//
//  ContentImageTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/13/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class ContentImageTableCell: UITableViewCell {
    @IBOutlet weak var baseImageView: UIImageView!
    
    var imageUrl : String!{
        didSet{
            baseImageView.load(url: imageUrl, withFixedSide: true)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
