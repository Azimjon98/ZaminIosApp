//
//  GalleryInsideMediaVC.swift
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

class GalleryInsideMediaVC: UITableViewController, IndicatorInfoProvider {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textSubtitle: UILabel!
    
    let realm = try! Realm()
    
    var allIds : [String]?
    var galleryNews : [SimpleNewsModel] = [SimpleNewsModel]()
    var estimatedHeights: [IndexPath: CGFloat] = [:]
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    var lastLocale: String = {
        UserDefaults.getLocale()
    }()
    var makingRequest: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Register nib file
        tableView.register(UINib(nibName: "GalleryNewsCell", bundle: nil), forCellReuseIdentifier: "galleryNewsCell")

        getGalleryNews(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyTabBarIndex.mediaLastIndex = 1
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
        
        if UserDefaults.getLocale() != lastLocale{
            getGalleryNews()
            lastLocale = UserDefaults.getLocale()
        }else if galleryNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    func reload(){
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
        
        if UserDefaults.getLocale() != lastLocale{
            getGalleryNews()
            lastLocale = UserDefaults.getLocale()
        }else if galleryNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        sender.endRefreshing()
        getGalleryNews(true)
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
       return IndicatorInfo(title: LanguageHelper.getString(stringId: .tab_gallery))
    }

    
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = galleryNews[selectedIndex]
            }
        }
        
    }
 

}

extension GalleryInsideMediaVC{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNewsCell", for: indexPath) as? GalleryNewsCell{
            cell.model = galleryNews[indexPath.row]
            cell.delegate = self
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.frame.size.height
        if let cell = cell as? GalleryNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
        
        if indexPath.row == galleryNews.count - 1{
            self.getGalleryNews()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
    }
}




extension GalleryInsideMediaVC{
    
    
    //MARK: Networking
    
    func getGalleryNews(_ fromBegin: Bool = false){
        if  makingRequest{
            return
        }
        makingRequest = true
        
        if  fromBegin{
            offset = 1
            self.galleryNews.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        print("offset: \(offset)")
        
        let req = Alamofire.request(Constants.URL_MEDIA_NEWS,
                          method: .get,
                          parameters: ApiHelper.getMediaNewsWithType(offset: offset, limit: limit, type: "1"))
        req.responseJSON {
            response in
            SVProgressHUD.dismiss()
            self.makingRequest = false
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo: nil,storagePolicy: .allowed)
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
                }else if  self.offset == 1{
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
        self.galleryNews.append(contentsOf: SimpleNewsModel.parse(json: json,type: 1) ?? [SimpleNewsModel]())
        
        self.titleView.isHidden = false
        self.tableView.removeBackView()
        if(galleryNews.count != 0){
            self.tableView.reloadData()
        }
    }
    
}



extension GalleryInsideMediaVC{
    
    func changeLanguage(){
        textTitle.text = LanguageHelper.getString(stringId: .title_foto)
        textSubtitle.text = LanguageHelper.getString(stringId: .message_foto)
    }
}

extension GalleryInsideMediaVC : MyWishListDelegate{
    
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



extension GalleryInsideMediaVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        getGalleryNews(true)
    }
    
}

extension GalleryInsideMediaVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = tableView.contentOffset.y
        let maxOffset = tableView.contentSize.height
        let frameSize = tableView.frame.size.height
        
        if maxOffset - frameSize - currentOffset <= 0, !makingRequest{
            tableView.addLoadingFooter()
            getGalleryNews()
        }
        
        
    }
    
}


extension GalleryInsideMediaVC: UITabBarControllerDelegate{
    
    func scrollToTop() {
        if !self.tableView.visibleCells.isEmpty {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
}
