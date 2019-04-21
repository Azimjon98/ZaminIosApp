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
        
        //TODO: Declare delegate methods
        tableView.delegate = self
        tableView.dataSource = self

        //TODO: Register nib file
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as! MediumNewsCell
        
        indexPath.section
        
        return cell
    }
    
    
    //Configure Table View
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        
    }
}
