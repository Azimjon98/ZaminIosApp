//
//  LastNewsTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/28/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class LastNewsTableCell: UITableViewCell {
    @IBOutlet weak var textLastNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changeLanguage()
    }

}


extension LastNewsTableCell{
    
    func changeLanguage(){
        textLastNews.text = LanguageHelper.getString(stringId: .text_last_news)
    }
}
