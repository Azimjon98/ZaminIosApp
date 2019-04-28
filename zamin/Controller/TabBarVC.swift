//
//  TabBarVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/23/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))

        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPressed", sender: self)
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "profilePressed", sender: self)
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
