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
        
        // Do any additional setup after loading the view.
        
    
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let audioController = sb.instantiateViewController(withIdentifier: "audioInsideMediaVC")
        let videoController = sb.instantiateViewController(withIdentifier: "videoInsideMediaVC")
        let galleryController = sb.instantiateViewController(withIdentifier: "galleryInsideMediaVC")
        
        return [audioController, videoController, galleryController]
//          return [AudioInsideMediaVC(), VideoInsideMediaVC(), GalleryInsideMediaVC()]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
