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

class TopNewsVC: UITableViewController{
    //TODO: Variables here
    var items : [SimpleNewsModel] = [SimpleNewsModel]()
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //TODO: Register nib file
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        
        //Configure table view for autoChange Height
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.isNavigationBarHidden = false
        
        getTopNews(true)
    }
    
    @IBAction func refreshWindow(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        getTopNews(true)
    }
    
    
    //TODO: Table View DataSource methods here
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView")
        return items.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
            cell.updateCell(m: items[indexPath.row])
            
            if indexPath.row == items.count - 1{
                self.getTopNews(false)
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    
    //TODO: Networking
    func getTopNews(_ fromBegin: Bool){
        if  fromBegin{
            offset = 1
            items.removeAll()
            tableView.reloadData()
        }
        
        print("Start searching:")
       
        SVProgressHUD.show()
        
        Alamofire.request(Constants.BASE_URL,
                          method: .get,
                          parameters: ApiHelper.getTopNews(offset: offset, limit: limit))
            .responseJSON {
                response in
                
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
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = items[selectedIndex]
            }
        }
    }
}
