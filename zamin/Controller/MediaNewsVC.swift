//
//  MediaNewsVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MediaNewsVC: SegmentedPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let audioController = sb.instantiateViewController(withIdentifier: "audioInsideMediaVC")
        let videoController = sb.instantiateViewController(withIdentifier: "videoInsideMediaVC")
        let galleryController = sb.instantiateViewController(withIdentifier: "galleryInsideMediaVC")
        
        return [videoController, galleryController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        changeLanguage()
    }

}


extension MediaNewsVC{
    func changeLanguage(){
        let currentIndex = segmentedControl.selectedSegmentIndex
        if currentIndex == 0, let vc = viewControllers[currentIndex] as? VideoInsideMediaVC{
            if vc.isViewLoaded{
                vc.reload()
            }
            
        }
        
        else if currentIndex == 1, let vc = viewControllers[currentIndex] as? GalleryInsideMediaVC{
            if vc.isViewLoaded{
                vc.reload()
            }
        }
        
        segmentedControl.setTitle(LanguageHelper.getString(stringId: .tab_video), forSegmentAt: 0)
        segmentedControl.setTitle(LanguageHelper.getString(stringId: .tab_gallery), forSegmentAt: 1)
    }
    
}
