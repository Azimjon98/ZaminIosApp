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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
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
        self.tabBarController?.delegate = self
        changeLanguage()
    }
    
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        print("SegmentClicked")
        switch sender.selectedSegmentIndex {
        case 0:
//               if let vc = viewControllers[0] as? VideoInsideMediaVC{
//                   if MyTabBarIndex.mediaLastIndex == 0, vc.isViewLoaded{
//                       vc.scrollToTop()
//                   }
//               }
            
            
            MyTabBarIndex.mediaLastIndex = 0
        case 1:
//            if let vc = viewControllers[1] as? GalleryInsideMediaVC{
//                if MyTabBarIndex.mediaLastIndex == 1, vc.isViewLoaded{
//                    vc.scrollToTop()
//                }
//            }
            
            MyTabBarIndex.mediaLastIndex = 1
        case 2:
            MyTabBarIndex.mediaLastIndex = 2
        default:
            break
        }
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

extension MediaNewsVC: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 3, MyTabBarIndex.tabBarIndex == tabBarIndex {
            
            switch segmentControl.selectedSegmentIndex {
            case 0:
                if let vc = viewControllers[0] as? VideoInsideMediaVC{
                    if MyTabBarIndex.mediaLastIndex == 0, vc.isViewLoaded{
                        vc.scrollToTop()
                    }
                }
                
            case 1:
                if let vc = viewControllers[1] as? GalleryInsideMediaVC{
                    if MyTabBarIndex.mediaLastIndex == 1, vc.isViewLoaded{
                        vc.scrollToTop()
                    }
                }
                
            case 2:
                break
            default:
                break
            }
        }
        MyTabBarIndex.tabBarIndex = tabBarIndex
    }
    
}
