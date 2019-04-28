//
//  HeaderNewsFeedCell.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/24/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class HeaderNewsFeedCell: UITableViewCell {
    @IBOutlet weak var audioLay: UIView!
    @IBOutlet weak var vidioLay: UIView!
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var mainNewsCollection: UICollectionView!
    @IBOutlet weak var lastNewsCollection: UICollectionView!
    @IBOutlet weak var audioNewsCollection: UICollectionView!
    @IBOutlet weak var videoNewsCollection: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        pageControl.transform = CGAffineTransform(scaleX: 2, y: 0.5)
        
//        pageControl.
        categoriesCollection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    //COLLECTIONVIEW DATASOURCE METHODS
    
    
}
