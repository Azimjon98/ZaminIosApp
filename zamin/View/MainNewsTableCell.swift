//
//  MainNewsTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/28/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class MainNewsTableCell: UITableViewCell {
    @IBOutlet weak var textmainNews: UILabel!
    
    
    @IBOutlet weak var collectionView: MainNewsCollection!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changeLanguage()
    }

}


extension MainNewsTableCell{
    
    func changeLanguage(){
        textmainNews.text = LanguageHelper.getString(stringId: .text_main_news)
    }
}
