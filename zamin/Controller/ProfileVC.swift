//
//  ProfileVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/22/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ProfileVC: UIViewController {
    @IBOutlet weak var textLogin: UILabel!
    @IBOutlet weak var textNotifications: UILabel!
    @IBOutlet weak var textCategories: UILabel!
    @IBOutlet weak var textListCategories: UILabel!
    @IBOutlet weak var textLanguage: UILabel!
    @IBOutlet weak var textCurrentLanguage: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
        img.changeColor(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        img2.changeColor(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        img3.changeColor(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        loginButton.changeColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        notificationButton.changeColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        categoriesButton.changeColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        languageButton.changeColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.setNotificationEnabled(notificationSwitch.isOn)
    }

    @IBAction func profileClicked(_ sender: Any) {
        presentAlert(message: LanguageHelper.getString(stringId: .text_login_alert_disabled))
    }
    
  
    @IBAction func changeLanguageSelected(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionUz = UIAlertAction(title: "O'zbek lotin", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            if("uz" != UserDefaults.getLocale()){
                self.changeLocale("uz")
            }
            
        }
        
        let actionKr = UIAlertAction(title: "Ўзбек кирил", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            if("kr" != UserDefaults.getLocale()){
                self.changeLocale("kr")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Ortga", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        actionCancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        alert.addAction(actionUz)
        alert.addAction(actionKr)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    func changeLocale(_ locale: String){
        SVProgressHUD.show()
        var lang: String?
        if locale == "uz" {lang =  "oz"}
        else if locale == "kr" {lang = "uz"}
        
        let req = Alamofire.request(Constants.URL_CATEGORIES,
                          method: .get,
                          parameters: ApiHelper.getAllCategories(lang!))
        req.responseJSON {
            response in
            
            if response.result.isSuccess{
                let data : JSON = JSON(response.result.value!)
                let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data! as Data , userInfo: nil,storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                
                var categories: [EntityCategoryModel] = [EntityCategoryModel]()
                for i in data.arrayValue{
                    categories.append(EntityCategoryModel.parse(json: i))
                }
                
                do{
                    try self.realm.write {
                        //save old categoires isEnabled State
                        let oldCategories: Results<EntityCategoryModel> = self.realm.objects(EntityCategoryModel.self)
                        for old in oldCategories{
                            for new in categories{
                                if old.categoryId == new.categoryId{
                                    new.isEnabled = old.isEnabled
                                }
                            }
                        }
                        
                        self.realm.delete(self.realm.objects(EntityCategoryModel.self))
                        self.realm.add(categories)
                        self.successfullyChanged(locale)
                    }
                    
                }catch{
                    print("ErrorPassingCategories: \(error)")
                    self.presentAlert(message: LanguageHelper.getString(stringId: .text_no_connection))
                    SVProgressHUD.dismiss()
                }
                
            }else{
                print("ErrorParsingCategories: " + String(describing: response.result.error))
                self.presentAlert(message: LanguageHelper.getString(stringId: .text_no_connection))
                SVProgressHUD.dismiss()
            }
                
        }
        
        
    }
    
    func successfullyChanged(_ locale: String){
        UserDefaults.setLocale(locale)
        changeLanguage()
        SVProgressHUD.dismiss()
    }
    
    func changeCategories(){
       
        
        
    }
    
    
}


extension ProfileVC{

    func changeLanguage(){
        navigationItem.title = LanguageHelper.getString(stringId: .toolbar_profile)
        textLogin.text = LanguageHelper.getString(stringId: .text_registration)
        textNotifications.text = LanguageHelper.getString(stringId: .text_notification)
        textCategories.text = LanguageHelper.getString(stringId: .text_categories)
        textLanguage.text = LanguageHelper.getString(stringId: .text_choose_language)
        textCurrentLanguage.text = LanguageHelper.getString(stringId: .language)
        notificationSwitch.setOn(UserDefaults.getNotificationEnabled(), animated: true)
    
        let enabledCategories = realm.objects(EntityCategoryModel.self).filter("isEnabled = true")
        var categoriesList = ""
        if enabledCategories.count != 0 {
            for i in 0...enabledCategories.count - 1{
                if  i == 2{
                    categoriesList.append("...")
                    break
                }
                if  i == 0{
                    categoriesList.append(enabledCategories[i].name)
                }else{
                    categoriesList.append(", " + enabledCategories[i].name)
                }
            }

        }
        
        textListCategories.text = categoriesList
    

    }
}

