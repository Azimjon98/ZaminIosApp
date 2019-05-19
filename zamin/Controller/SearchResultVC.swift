//
//  SearchResultVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/22/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import RealmSwift

class SearchResultVC: UITableViewController {

    enum SearchType{
        case category
        case tag
    }

    //MARK: Initial values
    var searchingType: SearchType!
    var searchingId : String!
    var searchTitle: String!
    
    let realm = try! Realm()
    
    var allIds : [String]?
    var items : [SimpleNewsModel] = [SimpleNewsModel]()
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchTitle
        
        //TODO: Register nib file
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        
        getNews(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        if items.count != 0 {
            tableView.reloadData()
        }
    }
    
    
    
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = items[selectedIndex]
            }
        }
    }
}






extension SearchResultVC{
    //TODO: Table View DataSource methods here
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
            cell.model = items[indexPath.row]
            cell.delegate = self
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MediumNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
        
        if indexPath.row == items.count - 1{
            self.getNews()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
}

extension SearchResultVC{
    
    
    //TODO: Networking
    func getNews(_ fromBegin: Bool = false){
        if  fromBegin{
            offset = 1
            items.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        var url: String!
        var options: [String: String]!
        
        if searchingType == .category{
            url = Constants.BASE_URL
            options = ApiHelper.getNewsWithCategory(offset: offset, limit: limit, categoryId: searchingId)
        }
        else if searchingType == .tag{
            url = Constants.URL_TAGS
            options = ApiHelper.getNewsWithTags(offset: offset, limit: limit, tagName: searchingId)
        }
        
        Alamofire.request(url,
                          method: .get,
                          parameters: options)
            .responseJSON {
                response in
                SVProgressHUD.dismiss()
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                     print("\(data)")
                    
                    self.parseNews(data)
                    self.offset += 1
                }else{
                    print("Error: " + String(describing: response.result.error))
                    
                    if self.offset == 1{
                        self.tableView.setBigEmptyView()
                        if let button = self.tableView.backgroundView?.viewWithTag(1010102) as? UIButton{
                            button.addTarget(self, action: #selector(self.refreshButtonClicked), for: .touchUpInside)
                        }
                    }
                }
                
        }
        
        
    }
    
    
    
    //TODO: - PARSING METHODS
    
    func parseNews(_ json: JSON){
        self.items.append(contentsOf: SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]())
        
        self.tableView.reloadData()
    }
    
}


extension SearchResultVC : MyWishListDelegate{
    
    func wished(model: SimpleNewsModel) {
        do{
            try realm.write {
                realm.add(model.convertToFavourites())
                allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
            }
        }catch{
            print("Error(TopNewsVC) adding to realm")
        }
    }
    
    
    
    func unwished(newsId: String) {
        
        do{
            try realm.write {
                let objectsToDelete = realm.objects(EntityFavouriteNewsModel.self).filter("newsId = %@", newsId)
                realm.delete(objectsToDelete)
                allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
            }
        }catch{
            print("Error(TopNewsVC) adding to realm")
        }
    }
    
}


extension SearchResultVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        getNews(true)
    }
    
}
