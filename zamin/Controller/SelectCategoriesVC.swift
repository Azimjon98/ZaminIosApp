//
//  SelectCategoriesVC.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/22/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit
import RealmSwift

class SelectCategoriesVC: UITableViewController {
    @IBOutlet var myTableView: UITableView!
    
    let realm = try! Realm()
    var categoryItems: [EntityCategoryModel] = [EntityCategoryModel]()
    
    let barEditItem: UIBarButtonItem = {
        var edit = UIBarButtonItem()
        edit.tintColor = #colorLiteral(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
        edit.title = "Tahrirlash"
        
        
        
        return edit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.isEditing = true

        // Do any additional setup after loading the view.
        
//        self.navigationItem.rightBarButtonItem = barEditItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
        loadFavourites()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCategories()
    }
    
    func loadFavourites(){
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
        navigationItem.title = LanguageHelper.getString(stringId: .text_choose_language)
        
    }
}
