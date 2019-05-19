//
//  NewsFeedVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/21/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import RealmSwift

class NewsFeedVC: UITableViewController {
    
    enum Identifiers : String{
        case categories = "categoriesTableCell"
        case main_news = "mainNewsTableCell"
        case page_control = "pageIndicatorsTableCell"
        case last_news = "lastNewsTableCell"
        case video_news = "videoNewsTableCell"
        
        func value() -> String{
            return self.rawValue
        }
    }
    
    //MARK Variables
    let realm = try! Realm()
    
    var offset : Int = 1
    var limit: String = "10"
    var currentMainNews = 0;
    var estimatedHeights: [IndexPath: CGFloat] = [:]
    
    var selectedModel : SimpleNewsModel?
    var selectedCategoryId : String = "-1"
    var categoryTitle: String = ""
    var lastLanguage: String = {
        UserDefaults.getLocale()
    }()
    var makingRequest: Bool = false
    
    var allIds : [String]?
    var categoryItems : Results<EntityCategoryModel>?
    var mainNewsItems : [SimpleNewsModel] = [SimpleNewsModel]()
    var lastNewsItems : [SimpleNewsModel] = [SimpleNewsModel]()
    var videoItems : [SimpleNewsModel] = [SimpleNewsModel]()
    var lastContinueItems : [SimpleNewsModel] = [SimpleNewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
        
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        tableView.register(UINib(nibName: "SmallNewsCell", bundle: nil), forCellReuseIdentifier: "smallNewsCell")
        tableView.register(UINib(nibName: "VideoNewsCell", bundle: nil), forCellReuseIdentifier: "videoNewsCell")
        
        loadNews()
        
        tableView.addLoadingFooter()
        tableView.tableFooterView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        
        if UserDefaults.getLocale() != lastLanguage{
            loadNews()
            lastLanguage = UserDefaults.getLocale()
        }else if lastNewsItems.count != 0 {
            tableView.reloadData()
        }
    }
    
    @IBAction func refreshWindow(_ sender: UIRefreshControl) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        sender.endRefreshing()
        loadNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let content = segue.destination as? ContentVC{
                content.model = self.selectedModel
            }
        }
        
        else if segue.identifier == "goToSearchResult"{
            if let searchResult = segue.destination as? SearchResultVC{
                searchResult.searchTitle = categoryTitle
                searchResult.searchingType = .category
                searchResult.searchingId = selectedCategoryId
            }
        }
    }
    
}




extension NewsFeedVC{
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastNewsItems.count != 0{
            return getItemsCount()
        }
        
        return 0
    }
    
    func getItemsCount() -> Int{
        return 5 + lastNewsItems.count + videoItems.count + lastContinueItems.count
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
                cell.isUserInteractionEnabled = false
                return cell
            }
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.last_news.value(), for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
            
        }
            
        else if (indexPath.row >= 4 && indexPath.row <= 9) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "smallNewsCell", for: indexPath) as? SmallNewsCell {
                cell.model = lastNewsItems[indexPath.row - 4]
                cell.delegate = self
                return cell
            }
            
        }
            
        else if indexPath.row == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.video_news.value(), for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
            
        }
        
        else if (indexPath.row >= 11 && indexPath.row <= 13){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "videoNewsCell", for: indexPath) as? VideoNewsCell {
                cell.model = videoItems[indexPath.row - 11]
                cell.delegate = self
                return cell
            }
        }
        
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
                cell.model = lastContinueItems[indexPath.row - 14]
                cell.delegate = self
                return cell
            }
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.frame.size.height
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
                cell.pageControl.currentPage = currentMainNews
            }
        }
        
        if let cell = cell as? SmallNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        } else if let cell = cell as? VideoNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        } else if let cell = cell as? MediumNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
    
    }
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row >= 4, indexPath.row <= 9{
            selectedModel = lastNewsItems[indexPath.row - 4]
        }
        
        else if indexPath.row >= 11, indexPath.row <= 13{
            selectedModel = videoItems[indexPath.row - 11]
        }
        
        else if indexPath.row >= 14{
            selectedModel = lastContinueItems[indexPath.row - 14]
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row == 0{
            if categoryItems?.count == 0{
                return 0.0
            }else {
                return 76.0
            }
        }
        
        else if  indexPath.row == 1{
            return 336.0
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
    }
    
}








extension NewsFeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: - COLLECTIONVIEW DATASOURCE METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView is CategoriesCollection{
            return categoryItems?.count ?? 0
        }
        
        else if collectionView is MainNewsCollection{
            return mainNewsItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is CategoriesCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell{
                cell.model = categoryItems?[indexPath.row]
                
                return cell
            }
        } else if collectionView is MainNewsCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainNewsCollectionCell", for: indexPath) as? MainNewsCollectionCell{
                cell.model = mainNewsItems[indexPath.row]
                cell.delegate = self

                return cell
            }
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView is MainNewsCollection{
            if let cell = cell as? MainNewsCollectionCell{
                if allIds?.contains(cell.model.newsId) ?? false{
                    cell.bookItem()
                } else{
                    cell.unbookItem()
                }
            }
            
//            //Update PageControlIndicators
//            currentMainNews = indexPath.item
//            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }

    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let velY = velocity.y
        
//        print(x, view.frame.width, x / view.frame.width, y, velX, velY)
        if  velY == 0{
            //Update PageControlIndicators
            currentMainNews = Int(x / view.frame.width)
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
        
    }
    
    
    //MARK: - COLLECTIONVIEW DELEGATE METHODS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is CategoriesCollection {
             return CGSize(width: 104, height: 68)
        } else if collectionView is MainNewsCollection {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumLineSpacing = 0.0
            
            return CGSize(width: collectionView.bounds.width, height: 309)
        }
        
        return CGSize(width: 12, height: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView is CategoriesCollection{
            //Change BackButton title
            categoryTitle = categoryItems![indexPath.item].name
            selectedCategoryId = categoryItems![indexPath.item].categoryId
            performSegue(withIdentifier: "goToSearchResult", sender: self)
        }
        
        else if collectionView is MainNewsCollection{
            selectedModel = mainNewsItems[indexPath.item]
            performSegue(withIdentifier: "goToContent", sender: self)
        }
    }
    

}





//MARK - Get Data
extension NewsFeedVC {
    
    //MARK: - NETWORKING AND DATABASE FETCHING
    
    func loadNews(){
        if makingRequest {
            return
        }
        makingRequest = true
        let count = realm.objects(EntityCategoryModel.self).count
        
        if  count == 0{
            getCategories()
        }else{
            categoryItems = realm.objects(EntityCategoryModel.self).filter("isEnabled = true")
            getMainNews()
        }
        
        
    }
    
    func getCategories(){
        let req = Alamofire.request(Constants.URL_CATEGORIES,
                          method: .get,
                          parameters: ApiHelper.getAllCategories())
        req.responseJSON {
            response in
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                
                self.parseCategories(data)
            }else{
                print("ErrorParsingCategories: " + String(describing: response.result.error))
                self.tableView.setBigEmptyView()
                if let button = self.tableView.backgroundView?.viewWithTag(1010102) as? UIButton{
                    button.addTarget(self, action: #selector(self.refreshButtonClicked), for: .touchUpInside)
                }
            }
        }
        
        
    }
    
    func getMainNews(){
        mainNewsItems.removeAll()
        lastNewsItems.removeAll()
        videoItems.removeAll()
        lastContinueItems.removeAll()
        
        tableView.reloadData()

        
        SVProgressHUD.show()
        
        let req = Alamofire.request(Constants.BASE_URL,
                          method: .get,
                          parameters: ApiHelper.getMainNews())
        req.responseJSON {
            response in
            
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                self.parseMainNews(data)
            }else{
                print("ErrorParsingMainNews: " + String(describing: response.result.error))
                let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
                
                if cachedResponse != nil{
                    let cachedJson = try! JSON(data: (cachedResponse?.data)!)
                    self.parseMainNews(cachedJson)
                }else {
                    SVProgressHUD.dismiss()
                    self.tableView.setBigEmptyView()
                    if let button = self.tableView.backgroundView?.viewWithTag(1010102) as? UIButton{
                        button.addTarget(self, action: #selector(self.refreshButtonClicked), for: .touchUpInside)
                    }
                    
                }
            }
                
        }
        
        
    }
    
    func getVideoNews(){
        
        let req = Alamofire.request(Constants.URL_MEDIA_NEWS,
                          method: .get,
                          parameters: ApiHelper.getMediaNewsWithType(offset: 1, limit: "3", type: "2"))
        req.responseJSON {
            response in
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                self.parseVideoNews(data)
            }else{
                print("ErrorPassingVideoNews: " + String(describing: response.result.error))
                let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
                
                if  cachedResponse != nil{
                    let cachedJson = try! JSON(data: (cachedResponse?.data)!)
                    self.parseVideoNews(cachedJson)
                    
                }else{
                    SVProgressHUD.dismiss()
                    self.tableView.setBigEmptyView()
                    if let button = self.tableView.backgroundView?.viewWithTag(1010102) as? UIButton{
                        button.addTarget(self, action: #selector(self.refreshButtonClicked), for: .touchUpInside)
                    }
                }
            }
                
        }
    }
    
    func getLastNews(_ fromBegin: Bool = false){
        if fromBegin{
            offset = 1
        }
        
        let req = Alamofire.request(Constants.BASE_URL,
                          method: .get,
                          parameters: ApiHelper.getLastNews(offset: offset, limit: limit))
        
        req.responseJSON {
            response in
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo:nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                
                self.parseLastNews(data)
                self.offset += 1
            }else{
                print("ErrorPassingLastNews: " + String(describing: response.result.error))
                let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
                
                if  cachedResponse != nil{
                    let cachedJson = try! JSON(data: (cachedResponse?.data)!)
                    self.parseLastNews(cachedJson)
                    self.offset += 1
                }else if self.offset == 1{
                    SVProgressHUD.dismiss()
                    self.tableView.setBigEmptyView()
                    if let button = self.tableView.backgroundView?.viewWithTag(1010102) as? UIButton{
                        button.addTarget(self, action: #selector(self.refreshButtonClicked), for: .touchUpInside)
                    }
                }
            }
                
        }
    }
    
   
    
    //TODO: - PARSING METHODS
    
    func parseCategories(_ json: JSON){
        for i in json.arrayValue{
            
            do{
                try realm.write {
                    realm.add(EntityCategoryModel.parse(json: i))
                }
                
            }catch{
                print("ErrorPassingCategories: \(error)")
            }
            
        }
        
        categoryItems = realm.objects(EntityCategoryModel.self).filter("isEnabled = true")
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        self.getMainNews()
    }
    
    func parseMainNews(_ json: JSON){
        self.mainNewsItems = SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]()
        self.getVideoNews()
    }

    func parseVideoNews(_ json: JSON){
        self.videoItems = SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]()
        self.getLastNews(true)
    }
    
    func parseLastNews(_ json: JSON){
        for newsItem in json["articles"].arrayValue{
            if self.lastNewsItems.count < 6{
                self.lastNewsItems.append(SimpleNewsModel.parse(json: newsItem, type: -1, withCategory: true))
            }else{
                self.lastContinueItems.append(SimpleNewsModel.parse(json: newsItem,type: -1, withCategory: true))
            }
        }
        
        SVProgressHUD.dismiss()
        self.tableView.removeBackView()
        makingRequest = false
        self.tableView.reloadData()
        tableView.tableFooterView?.isHidden = true
    }
    
}


extension NewsFeedVC : MyWishListDelegate{
    
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

extension NewsFeedVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        loadNews()
    }
    
}



extension NewsFeedVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = tableView.contentOffset.y
        let maxOffset = tableView.contentSize.height
        let frameSize = tableView.frame.size.height
        
        if maxOffset - frameSize - currentOffset <= 0, !makingRequest{
            makingRequest = true
            tableView.tableFooterView?.isHidden = false
            getLastNews()
        }
    
        print("offsets: \(currentOffset)    \(maxOffset)     \(frameSize)")
        
        
       
    }
    
}

extension NewsFeedVC: UITabBarControllerDelegate{

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                self.tableView.setcon
            }
            
        }
    }
    
}

