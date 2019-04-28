//
//  ContentVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/26/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class ContentVC: UIViewController {

    let barButtonItems: [UIBarButtonItem] = {
        var mbookmark = UIBarButtonItem()
        mbookmark.image = UIImage(named: "bookmark_inactive")
        
        
        var share = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareText))
        share.image = UIImage(named: "UIBarButtonSystemItemAction")
        
        return [mbookmark, share]
    }()
    
    var model: SimpleNewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = barButtonItems

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    
    @objc func shareText(){
        let textShare = [ "sd" ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
