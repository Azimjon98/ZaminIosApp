//
//  MediumNewsCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class MediumNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var bookmarkIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
