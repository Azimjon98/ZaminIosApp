//
//  AudioInsideMediaVC.swift
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

class AudioInsideMediaVC: UITableViewController, IndicatorInfoProvider  {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textSubtitle: UILabel!
    
    let realm = try! Realm()
    
    var allIds : [String]?
    var audioNews : [SimpleNewsModel] = [SimpleNewsModel]()
    var estimatedHeights: [IndexPath: CGFloat] = [:]
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    var lastLocale : String = {
        UserDefaults.getLocale()
    }()
    var makingRequest: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Register nib file
        tableView.register(UINib(nibName: "AudioNewsCell", bundle: nil), forCellReuseIdentifier: "audioNewsCell")
        
        getAudioNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
        
        if UserDefaults.getLocale() != lastLocale{
            getAudioNews()
            lastLocale = UserDefaults.getLocale()
        }else if audioNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    func reload(){
        allIds = realm.objects(EntityFavouriteNewsModel.self).map { return $0.newsId }
        changeLanguage()
        
        if UserDefaults.getLocale() != lastLocale{
            getAudioNews()
            lastLocale = UserDefaults.getLocale()
        }else if audioNews.count != 0 {
            tableView.reloadData()
        }
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        getAudioNews()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LanguageHelper.getString(stringId: .tab_audio))
    }
    
    
    //MARK Out METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContent"{
            if let dest: ContentVC = segue.destination as? ContentVC{
                dest.model = audioNews[selectedIndex]
            }
        }
        
    }


}





extension AudioInsideMediaVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "audioNewsCell", for: indexPath) as? AudioNewsCell{
            cell.model = audioNews[indexPath.row]

            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.frame.size.height
//        if let cell = cell as? AudioNewsCell{
//            if allIds?.contains(cell.model.newsId) ?? false{
//                cell.bookItem()
//            } else{
//                cell.unbookItem()
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
    }
}


extension AudioInsideMediaVC{
    
    func getAudioNews(_ fromBegin: Bool = true){
        if  makingRequest{
            return
        }
        makingRequest = true
        
        if  fromBegin{
            offset = 1
            self.audioNews.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        let req = Alamofire.request(Constants.URL_MEDIA_NEWS,
                                    method: .get,
                                    parameters: ApiHelper.getMediaNewsWithType(offset: offset, limit: limit, type: "3"))
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
                    self.makingRequest = false
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
        self.audioNews.append(contentsOf: SimpleNewsModel.parse(json: json, type: 3) ?? [SimpleNewsModel]())
        
        makingRequest = false
        titleView.isHidden = false
        tableView.removeBackView()
        if(audioNews.count != 0){
            self.tableView.reloadData()
        }
    }
    
}



extension AudioInsideMediaVC{
    
    func changeLanguage(){
        textTitle.text = LanguageHelper.getString(stringId: .title_audio_news)
        textSubtitle.text = LanguageHelper.getString(stringId: .messege_audio)
        
    }
}




extension AudioInsideMediaVC{
    
    @objc func refreshButtonClicked(sender: UIButton) {
        getAudioNews(true)
    }
    
}

extension AudioInsideMediaVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = tableView.contentOffset.y
        let maxOffset = tableView.contentSize.height
        let frameSize = tableView.frame.size.height
        
        if maxOffset - frameSize - currentOffset <= 0, !makingRequest{
            tableView.addLoadingFooter()
            getAudioNews()
        }
        
        
    }
    
}


extension AudioInsideMediaVC: UITabBarControllerDelegate{
    
    func scrollToTop() {
        if !self.tableView.visibleCells.isEmpty {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
}
