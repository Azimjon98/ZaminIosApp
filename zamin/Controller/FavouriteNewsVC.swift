//
//  FavouriteNewsVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteNewsVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let realm = try! Realm()
    
    var allIds: [String]?
    var favourites: Results<EntityFavouriteNewsModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "FavouriteNewsCell", bundle: nil), forCellReuseIdentifier: "favouriteNewsCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        loadFavourites()
        changeLanguage()
        
    }
    
    func loadFavourites(){
        favourites = realm.objects(EntityFavouriteNewsModel.self)
        tableView.reloadData()
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
