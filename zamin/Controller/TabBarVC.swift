//
//  TabBarVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/23/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SVProgressHUD

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))

        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPressed", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "profilePressed", sender: self)
    }
    

}



extension TabBarVC{
    
    func changeLanguage(){
        //hack for updating child VCs
        let currentIndex = self.selectedIndex
        self.selectedIndex = abs(1 - currentIndex)
        self.selectedIndex = abs(currentIndex)
        
        tabBar.items?[0].title = LanguageHelper.getString(stringId: .menu_news_feed)
        tabBar.items?[1].title = LanguageHelper.getString(stringId: .menu_top)
        tabBar.items?[2].title = LanguageHelper.getString(stringId: .menu_favourites)
        tabBar.items?[3].title = LanguageHelper.getString(stringId: .menu_media)
        
    }
}
