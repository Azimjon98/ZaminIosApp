//
//  VideoNewsTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/28/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class VideoNewsTableCell: UITableViewCell {
    @IBOutlet weak var textVideoNew: UILabel!
    @IBOutlet weak var videoAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changeLanguage()
    }

}

extension VideoNewsTableCell{
    
    func changeLanguage(){
        textVideoNew.text = LanguageHelper.getString(stringId: .text_video_news)
        videoAllButton.setTitle(LanguageHelper.getString(stringId: .text_all)
            , for: .normal)
    }
}
