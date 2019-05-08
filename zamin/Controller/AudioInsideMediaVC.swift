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
    
    var offset : Int = 1
    var limit: String = "10"
    var selectedIndex = 0
    var lastLocale : String = {
        UserDefaults.getLocale()
    }()

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
    
    //MARK: Networking
    
    func getAudioNews(_ fromBegin: Bool = true){
        if  fromBegin{
            offset = 1
            self.audioNews.removeAll()
            tableView.reloadData()
            SVProgressHUD.show()
        }
        
        Alamofire.request(Constants.URL_MEDIA_NEWS,
                          method: .get,
                          parameters: ApiHelper.getMediaNewsWithType(offset: offset, limit: limit, type: "3"))
            .responseJSON {
                response in
                SVProgressHUD.dismiss()
                
                if response.result.isSuccess{
                    let data : JSON = JSON(response.result.value!)
                    self.parseNews(data)
                    
                    self.offset += 1
                }else{
                    print("Error: " + String(describing: response.result.error))
                    if self.offset == 1{
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
        
        
        titleView.isHidden = false
        tableView.removeBackView()
        tableView.reloadData()
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
            
            if indexPath.row == audioNews.count - 1{
                self.getAudioNews(false)
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
