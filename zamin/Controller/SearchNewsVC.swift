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

class SearchNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //TODO: - Variables
    let urlSearch = "http://m.zamin.uz/api/v1/search.php"
    var items: [SimpleNewsModel] = [SimpleNewsModel]()
    
    var offset : Int = 0
    var limit: String = "10"
    var key: String = ""
    var selectedIndex: Int = 0
    
    @IBOutlet weak var searchView : UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Init searchView
        searchView.delegate = self
        //FIXME: - continue it
//        searchView.placeholder =
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
    }
    
    //TODO: - Netwotking
    
    func searchNews(_ fromBegin: Bool){
        //checking for whitespacings
        if  key.trim().isEmpty{
            return
        }
        
        if  fromBegin{
            offset = 1
            items.removeAll()
            tableView.reloadData()
        }
        
        print("Start searching: \(key)")
        SVProgressHUD.show()

        Alamofire.request(urlSearch, method: .get,parameters: ApiHelper.searchNewsWithTitle(offset: offset, limit: limit, key: key)).responseJSON  { (response) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                print(data)
                self.parseNews(data)
            
                self.offset += 1
            }else{
                print("Error: " + String(describing: response.result.error))
            }
            
        }
        
        
    
    }
    
    //TODO: - PARSING METHODS
    
    func parseNews(_ json: JSON){
        for i in json["articles"].arrayValue{
            let model : SimpleNewsModel = SimpleNewsModel()
            
            model.newsId =  i["newsIs"].stringValue
            model.categoryId = i["categoryID"].stringValue
            model.date = i["publishedAt"].stringValue
            model.imageUrl = i["urlToImage"].stringValue
            model.originalUrl = i["url"].stringValue
            model.title = i["title"].stringValue
            
            self.items.append(model)
        }
        
        self.tableView.reloadData()
    }
    
    //TODO: - DELEGATE METHODS
    
    //MARK: - DATASOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
            cell.updateCell(m: items[indexPath.row])
    
            if indexPath.row == items.count - 1{
                searchNews(false)
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
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
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = items[selectedIndex]
            }
        }
    }

}
