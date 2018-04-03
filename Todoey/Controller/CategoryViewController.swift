//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Admin on 2018-03-31.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    
    var todoeyCategories = [Todoey]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        //print(todoeyCategories[0].name)
        
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//        print(dataFilePath)
    }

    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoeyCategories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = todoeyCategories[indexPath.row].name
        return cell
    }

    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinaionVC =  segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinaionVC.selectedCategory = todoeyCategories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        print("Saving Data")
        do{
            
            try context.save()
            print("Data Saved")
        }
        catch{
            print("Error ppp: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){

        let request : NSFetchRequest<Todoey> = Todoey.fetchRequest()

        do {
            todoeyCategories = try context.fetch(request)
            print("Fetching Array")
            print(todoeyCategories)
        }catch{
            print("Error ppp: \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Category
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catrgory", style: .default) { (action) in
            
            let newCategory = Todoey(context : self.context)
            newCategory.name = textField.text!

            self.todoeyCategories.append(newCategory)

            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Category"
        }
        present(alert, animated: true, completion: nil)
    }
}
