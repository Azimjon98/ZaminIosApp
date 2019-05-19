//
//  SelectCategoriesVC.swift
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

class SelectCategoriesVC: UITableViewController {
    @IBOutlet var myTableView: UITableView!
    
    let realm = try! Realm()
    var categoryItems: [EntityCategoryModel] = [EntityCategoryModel]()
    
    let barEditItem: UIBarButtonItem = {
        var edit = UIBarButtonItem()
        edit.tintColor = #colorLiteral(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
        edit.title = "reset"
        
        return edit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.isEditing = true

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = barEditItem
        
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(resetClicked)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
        loadFavourites()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCategories()
    }
    
    func loadFavourites(){
        categoryItems.removeAll()
        for item in realm.objects(EntityCategoryModel.self){
            let m = EntityCategoryModel()
            m.categoryId = item.categoryId
            m.isEnabled = item.isEnabled
            m.name = item.name
            m.imageUrl = item.imageUrl
            
            categoryItems.append(m)
        }
        
        myTableView.reloadData()
    }
    
    func saveCategories(){
        
        do{
            try realm.write {
                realm.delete(realm.objects(EntityCategoryModel.self))
                for i in categoryItems{
                    realm.add(i)
                }
            }
        }catch {
            print("ERROR: changing Categories!: \(error)")
        }
        
    }
    
    @objc func resetClicked(sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Barcha o'zgarishlarni bekor qilmoqchimisiz", message: "orqaga qaytishning iloji bo'lmaydi", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "ortga", style: .destructive) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "ha", style: .cancel) { (action) in
            self.executeReset()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func executeReset(){
        SVProgressHUD.show()
        let req = Alamofire.request(Constants.URL_CATEGORIES,
                                    method: .get,
                                    parameters: ApiHelper.getAllCategories())
        
        let cachedResponse = URLCache.shared.cachedResponse(for: req.request!)
        
        if  cachedResponse != nil{
            let cachedJson = try! JSON(data: (cachedResponse?.data)!)
            
            var categories: [EntityCategoryModel] = [EntityCategoryModel]()
            
            for i in cachedJson.arrayValue{
                categories.append(EntityCategoryModel.parse(json: i))
            }
            
            do{
                try realm.write {
                    self.realm.delete(self.realm.objects(EntityCategoryModel.self))
                    self.realm.add(categories)
                }
                
            }catch{
                print("ErrorPassingCategories: \(error)")
            }
            
            loadFavourites()
            SVProgressHUD.dismiss()
        }
    }

}

extension SelectCategoriesVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCategoryCell", for: indexPath)
        
        cell.editingAccessoryType =  categoryItems[indexPath.row].isEnabled ? .checkmark : .none
        cell.accessoryType =  categoryItems[indexPath.row].isEnabled ? .checkmark : .none
        cell.textLabel?.text = categoryItems[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        categoryItems[indexPath.row].isEnabled = !categoryItems[indexPath.row].isEnabled
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = categoryItems[sourceIndexPath.row]
        
        categoryItems.remove(at: sourceIndexPath.row)
        categoryItems.insert(movedItem, at: destinationIndexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}





extension SelectCategoriesVC{
    
    func changeLanguage(){
        navigationItem.title = LanguageHelper.getString(stringId: .title_select_categories)
        
    }
}
