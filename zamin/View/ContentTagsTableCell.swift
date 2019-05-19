//
//  ContentTagsTableCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/30/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class ContentTagsTableCell: UITableViewCell {
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var flowLayout: FlowLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tagsCollection.isPagingEnabled = false
        tagsCollection.isScrollEnabled = false
        
        self.tagsCollection.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagsCollectionViewCell")
        
        self.flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    
}
