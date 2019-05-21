//
//  SearchNewsVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/22/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import RealmSwift

class SearchNewsVC: UIViewController {
    @IBOutlet weak var searchView : UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()

    //TODO: - Variables
    var items: [SimpleNewsModel] = [SimpleNewsModel]()
    var allIds : [String]?
    var estimatedHeights: [IndexPath: CGFloat] = [:]
    
    var noItems:Bool = false
    var offset : Int = 0
    var limit: String = "10"
    var key: String = ""
    var selectedIndex: Int = 0
    var makingRequest: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: - continue it
//        searchView.placeholder =
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.hideKeyboardWhenTappedAround()
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        changeLanguage()
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

extension SearchNewsVC{
    
    //TODO: - Netwotking
    
    func searchNews(_ fromBegin: Bool = false){
        if makingRequest {
            return
        }
        makingRequest = true
        self.tableView.removeBackView()
        
        
        if  fromBegin{
            noItems = false
            offset = 1
            items.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        Alamofire.request(Constants.URL_SEARCH_NEWS, method: .get,parameters: ApiHelper.searchNewsWithTitle(offset: offset, limit: limit, key: key)).responseJSON  { (response) in
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                
                self.parseNews(data)
                self.offset += 1
            }else{
                self.makingRequest = false
                print("Error: " + String(describing: response.result.error))
                if self.offset == 1{
                    self.tableView.setBigEmptyView()
                }
            }
            
        }
        
        
        
    }
    
    //TODO: - PARSING METHODS
    
    func parseNews(_ json: JSON){
        let items = SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]()
        
        
        makingRequest = false
        if  items.count == 0{
            if  offset == 1{
                self.tableView.setBigNoItemView()
            }
            noItems = true
        }else{
            self.items.append(contentsOf: items)
            self.tableView.reloadData()
        }
    }
    
}




extension SearchNewsVC : UITableViewDelegate, UITableViewDataSource{
    //MARK: - DATASOURCE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
            cell.model = items[indexPath.row]
            cell.delegate = self
            
            return cell
        }
        
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.frame.size.height
        if let cell = cell as? MediumNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
    }
    
    //TODO: - DELEGATE METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
    }
    
    
}

extension SearchNewsVC : UISearchBarDelegate{
    //MARK: - Search Bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.trim().isEmpty { key = text} else { return}
        
        searchNews(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.resignFirstResponder()
        
        if let text = searchBar.text, !text.trim().isEmpty {
            //check for changings
            if key == text {
                return
            }
            key = text
            
        } else { return }
        
        searchNews(true)
    }
}

extension SearchNewsVC{
    
    func changeLanguage(){
        searchView.placeholder = LanguageHelper.getString(stringId: .text_news)
    }
}


extension SearchNewsVC : MyWishListDelegate{
    
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




extension SearchNewsVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = tableView.contentOffset.y
        let maxOffset = tableView.contentSize.height
        let frameSize = tableView.frame.size.height
        
        
        if maxOffset - frameSize - currentOffset <= 0, !makingRequest{
            print("false is best")
            tableView.addLoadingFooter()
            searchNews()
        }
        
        
        
    }
    
}

