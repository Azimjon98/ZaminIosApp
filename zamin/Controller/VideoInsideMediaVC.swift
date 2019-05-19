//
//  VideoInsideMediaVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/25/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD
import SwiftyJSON
import Alamofire
import RealmSwift

class VideoInsideMediaVC: UITableViewController, IndicatorInfoProvider {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textSubtitle: UILabel!
    
    let realm = try! Realm()
    
    var allIds : [String]?
    var videoNews : [SimpleNewsModel] = [SimpleNewsModel]()
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    var lastLanguage: String = {
        UserDefaults.getLocale()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: Register nib file
        tableView.register(UINib(nibName: "VideoNewsCell", bundle: nil), forCellReuseIdentifier: "videoNewsCell")
        
        getVideoNews(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
        
        if UserDefaults.getLocale() != lastLanguage{
            getVideoNews()
            lastLanguage = UserDefaults.getLocale()
        }else if videoNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    func reload(){
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
    
        if UserDefaults.getLocale() != lastLanguage{
            getVideoNews()
            lastLanguage = UserDefaults.getLocale()
        }else if videoNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    @IBAction func reloadAction(_ sender: UIRefreshControl) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        sender.endRefreshing()
        getVideoNews(true)
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LanguageHelper.getString(stringId: .tab_video))
    }
    
    //MARK: Networking
    
    
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = videoNews[selectedIndex]
            }
        }
        
    }

   
}

extension VideoInsideMediaVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videoNewsCell", for: indexPath) as? VideoNewsCell{
            cell.model = videoNews[indexPath.row]
            cell.delegate = self
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? VideoNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
        
        if indexPath.row == videoNews.count - 1{
            self.getVideoNews(false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
}



extension VideoInsideMediaVC{
   
    func getVideoNews(_ fromBegin: Bool = false){
        if  fromBegin{
            offset = 1
            self.videoNews.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        
        let req = Alamofire.request(Constants.URL_MEDIA_NEWS,
                          method: .get,
                          parameters: ApiHelper.getMediaNewsWithType(offset: offset, limit: limit, type: "2"))
        req.responseJSON {
            response in
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                self.parseNews(data)
                self.offset += 1
            }else{
                print("Error: " + String(describing: response.result.error))
                let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
                
                if  cachedResponse != nil{
                    let cachedJson = try! JSON(data: (cachedResponse?.data)!)
                    self.parseNews(cachedJson)
                    self.offset += 1
                }else if self.offset == 1{
                    self.titleView.isHidden = true
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
         self.videoNews.append(contentsOf: SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]())
        
        self.titleView.isHidden = false
        self.tableView.removeBackView()
        self.tableView.reloadData()
    }
    
}



extension VideoInsideMediaVC{
    
    func changeLanguage(){
        textTitle.text = LanguageHelper.getString(stringId: .title_video_news)
        textSubtitle.text = LanguageHelper.getString(stringId: .message_video)
    }
}

extension VideoInsideMediaVC : MyWishListDelegate{
    
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


extension VideoInsideMediaVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        getVideoNews(true)
    }
    
}
