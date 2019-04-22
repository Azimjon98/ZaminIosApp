//
//  TopTabVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class TopTabVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //TODO: Variables here
    var items : [SimpleNewsmodel]?

    @IBOutlet weak var appBar: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        appBar.layer.shadowRadius = 5
        appBar.layer.shadowOpacity = 0.1
        appBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        //TODO: Declare delegate methods
        tableView.delegate = self
        tableView.dataSource = self

        //TODO: Register nib file
        tableView.register(UINib(nibName: "GalleryNewsCell", bundle: nil), forCellReuseIdentifier: "galleryNewsCell")
        
        //Configure table view for autoChange Height
        configureTableView()
        
        tableView.separatorStyle = .none
    }
    
    //TODO: Table View DataSource methods here
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView")
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNewsCell", for: indexPath) as? GalleryNewsCell{
            if indexPath.row % 2 == 0{
//                cell.updateItem(text: "Slomdsadsa")
            }else{
//                cell.updateItem(text: "Slomdsadsa Slomdsadsa Slomdsadsa Slomdsadsa Slomdsadsa Slomdsadsa ")
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    //Configure Table View
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        
    }
}
