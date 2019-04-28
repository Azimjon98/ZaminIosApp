//
//  NewsFeedVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit

class NewsFeedVC: UITableViewController {
    
    enum Identifiers : String{
        case categories = "categoriesTableCell"
        case main_news = "mainNewsTableCell"
        case page_control = "pageIndicatorsTableCell"
        case last_news = "lastNewsTableCell"
        case video_news = "videoNewsTableCell"
        case last_continue = "mediumNewsCell"
        
        func value() -> String{
            return self.rawValue
        }
    }
    
    //MARK Variables
    var selectedIndex = -1
    
    var items: [SimpleNewsModel] = [SimpleNewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")

    }
    
    @IBAction func refreshWindow(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    //TABLEVIEW DATASOURCE METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.categories.value(), for: indexPath) as? CategoriesTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.row == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.main_news.value(), for: indexPath) as? MainNewsTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.row == 2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.page_control.value(), for: indexPath) as? PageIndicatorsTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.row == 3{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.last_news.value(), for: indexPath) as? LastNewsTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.row == 4{
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.video_news.value(), for: indexPath) as? VideoNewsTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.last_continue.value(), for: indexPath) as? MediumNewsCell{
                return cell
            }
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == 0{
            if let cell = cell as? CategoriesTableCell{
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
            }
        } else if indexPath.item == 1{
            if let cell = cell as? MainNewsTableCell{
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
            }
        }else if indexPath.item == 2{
            if let cell = cell as? PageIndicatorsTableCell{
                cell.pageControl.numberOfPages = 10
                cell.pageControl.currentPage = 3
//                cell.collectionView.dataSource = self
            }
        }else if indexPath.item == 3{
            if let cell = cell as? LastNewsTableCell{
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.collectionView.isScrollEnabled = false
            }
        }else if indexPath.item == 4{
            if let cell = cell as? VideoNewsTableCell{
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.collectionView.isScrollEnabled = false
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item < 5{
            return
        }
        
        selectedIndex = indexPath.item - 5
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 300.0
        } else if indexPath.row == 4{
            return 300.0
        } else{
            return UITableView.automaticDimension
        }
        
    }
}






extension NewsFeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is CategoriesCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell{
                cell.title = "Salom"
                
                return cell
            }
        } else if collectionView is MainNewsCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainNewsCollectionCell", for: indexPath) as? MainNewsCollectionCell{
                
                
                return cell
            }
        } else if collectionView is LastNewsCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lastNewsCollectionCell", for: indexPath) as? LastNewsCollectionCell{
                
                return cell
            }
        } else if collectionView is VideoNewsCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoNewsCollectionCell", for: indexPath) as? VideoNewsCollectionCell{
                
                
                return cell
            }
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is CategoriesCollection {
             return CGSize(width: 104, height: 68)
        } else if collectionView is MainNewsCollection {
            return CGSize(width: collectionView.bounds.width, height: 309)
        }
        
        return CGSize(width: 12, height: 12)
    }
    

    
    //FIXME
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView is MainNewsCollection{
            return 0
        }else{
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            
            return layout.minimumLineSpacing
        }
    }
    
    

}
