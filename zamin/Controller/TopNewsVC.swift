//
//  TopTabVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/19/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import RealmSwift

class TopNewsVC: UITableViewController{
    //TODO: Variables here
    var items : [SimpleNewsModel] = [SimpleNewsModel]()
    var allIds : [String]?
    
    let realm = try! Realm()
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    var lastLanguage: String = {
        UserDefaults.getLocale()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Register nib file
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")

        getTopNews(true)
    }
    
    @IBAction func refreshWindow(_ sender: UIRefreshControl) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        sender.endRefreshing()
        getTopNews(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        
        if UserDefaults.getLocale() != lastLanguage{
            getTopNews(true)
            lastLanguage = UserDefaults.getLocale()
        }else if items.count != 0 {
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






extension TopNewsVC{
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
            tableView.isScrollEnabled = false
            tableView.isScrollEnabled = true
            
            self.getTopNews()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
}

extension TopNewsVC{
    
    //TODO: Networking
    func getTopNews(_ fromBegin: Bool = false){
        if  fromBegin{
            self.tableView.removeBackView()
            offset = 1
            items.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        let req = Alamofire.request(Constants.BASE_URL,
                          method: .get,
                          parameters: ApiHelper.getTopNews(offset: offset, limit: limit))
            
        req.responseJSON {
            response in
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                print("\(data)")
                
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo: nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                self.parseNews(data)
                
                self.offset += 1
            }else{
                print("Error(TopNews): GettingLastNews" + String(describing: response.result.error))
                let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
                
                if  cachedResponse != nil{
                    let cachedJson = try! JSON(data: (cachedResponse?.data)!)
                    self.parseNews(cachedJson)
                    self.offset += 1
                }else if self.offset == 1{
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
        let addingItems = SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]()
        self.items.append(contentsOf: addingItems)
        
        if(addingItems.count != 0){
            self.tableView.reloadData()
        }
    }
    
}

extension TopNewsVC : MyWishListDelegate{
    
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

extension TopNewsVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        getTopNews(true)
    }
    
}
