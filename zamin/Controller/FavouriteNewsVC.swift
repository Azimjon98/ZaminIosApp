//
//  FavouriteNewsVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FavouriteNewsVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let realm = try! Realm()
    
    var contentUpdating = false
    var allIds: [String]?
    var favourites: Results<EntityFavouriteNewsModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        tableView.register(UINib(nibName: "FavouriteNewsCell", bundle: nil), forCellReuseIdentifier: "favouriteNewsCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        loadFavourites()
        changeLanguage()
        
    }
    
    func loadFavourites(){
        favourites = realm.objects(EntityFavouriteNewsModel.self)
        
        
        for favourite in favourites!{
            if favourite.lastLocale != UserDefaults.getLocale(){
                SVProgressHUD.show()
                contentUpdating = true
                updateItem(model: favourite)
                return
            }
        }
        SVProgressHUD.dismiss()
        contentUpdating = false
        tableView.reloadData()
    }
    
    func updateItem(model: EntityFavouriteNewsModel){
        
        let req = Alamofire.request(Constants.URL_CONTENT,
                                    method: .get,
                                    parameters: ApiHelper.getContentWithId(id: model.newsId))
        
        let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
        
        if  cachedResponse != nil{
            
            let cachedJson = try! JSON(data: (cachedResponse?.data)!)
            do{
                try realm.write {
                    model.update(json: cachedJson)
                }
            }catch{
                print("Error(Favourites): updateModel")
            }
            self.loadFavourites()
            
        } else{
            
            req.responseJSON {
                response in
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                    let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                    
                    do{
                        try self.realm.write {
                            model.update(json: data)
                            
                        }
                    }catch{
                        print("Error(Favourites): updateModel")
                    }
                    self.loadFavourites()
                    
                }else{
                    print("ErrorParsingCategories: " + String(describing: response.result.error))
                    SVProgressHUD.dismiss()
                    self.contentUpdating = false
                    self.tableView.reloadData()
                }
                
            }

            
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContentVC{
            destination.model = favourites![tableView.indexPathForSelectedRow?.row ?? 0].convertToSimple()
        }
    }

}


extension FavouriteNewsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  favourites?.count == 0{
            subtitleLabel.text = LanguageHelper.getString(stringId: .text_no_favourites)
        }else{
            subtitleLabel.text = LanguageHelper.getString(stringId: .message_favourites)
        }
        
        if  contentUpdating{
            return 0
        }
        return favourites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteNewsCell", for: indexPath) as? FavouriteNewsCell{
            cell.delegate = self
            cell.index = indexPath.row + 1
            cell.model = favourites?[indexPath.row] ?? EntityFavouriteNewsModel()
//
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToContent", sender: self)
    }
}



extension FavouriteNewsVC{
    
    func changeLanguage(){
        titleLabel.text = LanguageHelper.getString(stringId: .title_favourites)
        subtitleLabel.text = LanguageHelper.getString(stringId: .message_favourites)
    }
}



extension FavouriteNewsVC : MyWishListDelegate{
    
    func wished(model: SimpleNewsModel) {
       
    }
    
    
    
    func unwished(newsId: String) {
        
        do{
            try realm.write {
                let objectsToDelete = realm.objects(EntityFavouriteNewsModel.self).filter("newsId = %@", newsId)
                realm.delete(objectsToDelete)
                self.tableView.reloadData()
            }
        }catch{
            print("Error(TopNewsVC) adding to realm")
        }
    }
    
}


extension FavouriteNewsVC: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 2, MyTabBarIndex.tabBarIndex == tabBarIndex, !self.tableView.visibleCells.isEmpty {
            
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                tableView.row
            }
            
        }
        MyTabBarIndex.tabBarIndex = tabBarIndex
    }
    
}
