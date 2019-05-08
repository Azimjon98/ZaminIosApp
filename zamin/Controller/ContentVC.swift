//
//  ContentVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/26/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SVProgressHUD
import WebKit

class ContentVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let bookmarkButton: UIBarButtonItem = {
        var mbookmark = UIBarButtonItem()
        mbookmark.image = UIImage(named: "bookmark_active")
        
        return mbookmark
    }()
    
    let shareButton: UIBarButtonItem = {
        var share = UIBarButtonItem()
        share.image = UIImage(named: "share")
        
        return share
    }()
    
    var contentModel : ContentNewsModel!{
        didSet{
            self.navigationItem.setRightBarButtonItems([bookmarkButton, shareButton], animated: true)
            self.navigationItem.rightBarButtonItems![0].target = self
            self.navigationItem.rightBarButtonItems![0].action = #selector(bookmarkPressed)
            self.navigationItem.rightBarButtonItems![1].target = self
            self.navigationItem.rightBarButtonItems![1].action = #selector(shareText)
            
            //find is news wished
            if allIds?.contains(contentModel.newsId) ?? false{
                contentModel.isWished = true
            }
            
            if contentModel.isWished{
                let myImage = UIImage(named: "bookmark_active")
                self.navigationItem.rightBarButtonItems![0].image = myImage?.withRenderingMode(.alwaysOriginal)
            
            }else{
                self.navigationItem.rightBarButtonItems![0].image = UIImage(named: "bookmark_inactive")
            }
            
            
        }
    }
    
    var model: SimpleNewsModel!
    
    
    //MARK Variables
    let realm = try! Realm()
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = -1
    var contentLoaded: Bool = false
    var myContentUrl: String = ""
    
    var allIds : [String]?
    var lastNewsItems : [SimpleNewsModel] = [SimpleNewsModel]()
    var tagItems : [TagModel] = [TagModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "MediumNewsCell", bundle: nil), forCellReuseIdentifier: "mediumNewsCell")
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.startTopProgress(topView: self.view, height: 2, backColor: #colorLiteral(red: 1, green: 0.9333333333, blue: 0.9333333333, alpha: 1), frontColor: #colorLiteral(red: 0.7803921569, green: 0.09803921569, blue: 0.137254902, alpha: 1))
        
        getNewsContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { $0.newsId }
        if lastNewsItems.count != 0 {
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWebView"{
            if let destination = segue.destination as? WebViewVC{
                
                destination.contentUrl = myContentUrl
            }
        }
    }
    
    
    
    @objc func shareText(sender: UIBarButtonItem){
        let textShare = [ String(contentModel?.originalUrl ?? "") ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func bookmarkPressed(sender: UIBarButtonItem){
        
        contentModel.isWished = !contentModel.isWished
        if contentModel.isWished{
            bookmarkButton.image = UIImage(named: "bookmark_active")
            bookmarkButton.image = bookmarkButton.image?.withRenderingMode(.alwaysOriginal)
            
            do{
                try realm.write {
                    realm.add(contentModel.convertToFavourites())
                }
            }catch{
                print("Error(TopNewsVC) adding to realm")
            }
            
        } else{
            bookmarkButton.image = UIImage(named: "bookmark_inactive")
            unwished(newsId: contentModel.newsId)
        }
        
        
    }
    
    
}


extension ContentVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastNewsItems.count != 0{
            return getItemCount()
        }
        
        return 0
    }
    
    func getItemCount() -> Int{
        return 4 + lastNewsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "contentHeaderCell", for: indexPath) as? ContentHeaderTableCell{
                cell.model = contentModel
                cell.selectionStyle = .none
                return cell
            }
        }
            
        else if indexPath.row == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "contentWebViewCell", for: indexPath) as? ContentWebViewTableCell{
                cell.delegate = self
                cell.selectionStyle = .none
                
                return cell
            }
        }
            
        else if indexPath.row == 2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "contentTagsCell", for: indexPath) as? ContentTagsTableCell{
                cell.selectionStyle = .none
                return cell
            }
        }
            
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentSeparatorCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
            
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mediumNewsCell", for: indexPath) as? MediumNewsCell{
                cell.model = lastNewsItems[indexPath.item - 4]
                cell.delegate = self
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        
        if indexPath.row >= 4{
            let st = UIStoryboard(name: "Main", bundle: nil)
            if let contentVC: ContentVC = st.instantiateViewController(withIdentifier: "goToContent") as? ContentVC{
                contentVC.model = lastNewsItems[indexPath.row - 4]
                self.navigationController?.pushViewController(contentVC, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MediumNewsCell{
            if allIds?.contains(cell.model.newsId) ?? false{
                cell.bookItem()
            } else{
                cell.unbookItem()
            }
        }
        
        if cell is ContentTagsTableCell {
            if let cell = cell as? ContentTagsTableCell{
                cell.tagsCollection.delegate = self
                cell.tagsCollection.dataSource = self
                cell.tagsCollection.reloadData()
            }
        }
        
        if let cell = cell as? ContentWebViewTableCell{
            
            if !contentLoaded{
                cell.contentUrl = contentModel?.contentUrl
            }
            
        }
        
        
        
        if indexPath.row == getItemCount() - 1{
            getLastNews()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2, tagItems.count == 0{
            return 0
        }
        
        else { return UITableView.automaticDimension}
    }
    
}

extension ContentVC: ContentLoadingDelegate{
    
    func contentDidLoad() {
        if !contentLoaded{
            self.stopTopProgress()
            contentLoaded = true
            tableView.reloadData()
        }
    }
    
    func contentAction(linkUrl url: String) {
        print("inContent: \(url)")
        myContentUrl = url
        performSegue(withIdentifier: "goToWebView", sender: self)
    }
    
}



extension ContentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: DATASOURCE METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCollectionViewCell", for: indexPath) as? TagCollectionCell{
            cell.model = tagItems[indexPath.item]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 12, height: 12)
    }
    
}





//MARK - Get Data
extension ContentVC {
    //MARK: - NETWORKING AND DATABASE FETCHING
    
    func getNewsContent(){
        SVProgressHUD.show()
        
        Alamofire.request(Constants.URL_CONTENT,
                          method: .get,
                          parameters: ApiHelper.getContentWithId(id: model.newsId))
            .responseJSON {
                response in
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                    self.parseNewsContent(data)
                    self.getTags()
                }else{
                    print("ErrorParsingCategories: " + String(describing: response.result.error))
                }
                
        }
        
        
    }
    
    func getTags(){
        
        Alamofire.request(Constants.URL_TAGS,
                          method: .get,
                          parameters: ApiHelper.getContentTags(id: model.newsId))
            .responseJSON {
                response in
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                    
                    self.parseTags(data)
                    self.getLastNews(true)
                    
                }else{
                    print("ErrorParsingMainNews: " + String(describing: response.result.error))
                }
                
        }
        
        
    }
    
    func getLastNews(_ fromBegin: Bool = false){
        if fromBegin{
            offset = 1
            lastNewsItems.removeAll()
        }
        
        Alamofire.request(Constants.BASE_URL,
                          method: .get,
                          parameters: ApiHelper.getLastNews(offset: offset, limit: limit))
            .responseJSON {
                response in
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                    
                    self.parseLastNews(data)
                    
                    self.offset += 1
                }else{
                    print("ErrorPassingLastNews: " + String(describing: response.result.error))
                }
                
        }
    }
    
    //TODO: - PARSING METHODS
    
    func parseNewsContent(_ json: JSON){
        contentModel = ContentNewsModel.parse(json: json)
    }
    
    func parseTags(_ json: JSON){
        tagItems = TagModel.parse(json)
    }
    
    func parseLastNews(_ json: JSON){
        self.lastNewsItems.append(contentsOf: SimpleNewsModel.parse(json: json) ?? [SimpleNewsModel]())
        
        for i in 0...lastNewsItems.count - 1{
            if lastNewsItems[i].newsId == model.newsId{
                lastNewsItems.remove(at: i)
                break
            }
        }
        
        
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
}


extension ContentVC : MyWishListDelegate{
    
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
