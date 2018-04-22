//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Admin on 2018-03-31.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var backgroundColor : String = ""
    let realm = try! Realm()
    
    var todoeyCategories: Results<Category>? // making optional instead of forceunwrapping (!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 80.0
      //  print("2")
        //print(todoeyCategories[0].name)
        
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//        print(dataFilePath)
    }

    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoeyCategories?.count ?? 1 // Nil Coalescing Operator (if nil return 1)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath   )
        cell.textLabel?.text = todoeyCategories?[indexPath.row].name ?? "No Categories Added Yet"
        
        //backgroundColor = UIColor.randomFlat.hexValue()
        if let category = todoeyCategories?[indexPath.row] {
            guard let color = UIColor(hexString : category.bgColor) else{fatalError()}
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }

    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinaionVC =  segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinaionVC.selectedCategory = todoeyCategories?[indexPath.row]
            
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        print("Saving Data")
        do{
            
            try realm.write {
                realm.add(category)
            }
            print("Data Saved")
        }
        catch{
            print("Error ppp: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){

        todoeyCategories = realm.objects(Category.self)

        tableView.reloadData()
    }
    //MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryDeletion = self.todoeyCategories?[indexPath.row]{
            do{
                try   self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
            }catch{
                print("Error removing category \(error)")
            }
        }
        //            tableView.reloadData() comment b/c of expansion styles

    }
    
    //MARK: - Add New Category
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.bgColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Category"
        }
        present(alert, animated: true, completion: nil)
    }
}


