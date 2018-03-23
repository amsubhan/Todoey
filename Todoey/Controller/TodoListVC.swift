//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 2018-03-19.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //print(dataFilePath!)
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            print("flag 1")
//            itemArray = items
//        }
      
//       loadItems()    
    }
    
    
    //MARK - TabelView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
    }

    //MARK - TableView Delegate Methods
    
    //methods to get data/listen from UI
    
    //listen when row is selected!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
       // tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Todo items
    

    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when user click add btn
//            print(textField.text)
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
            print(self.itemArray[self.itemArray.count - 1])
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manuplation Methods
    
    //save data in NSCoder by encoding technique
    func saveItems(){
        //let encoder = PropertyListEncoder()
        
        do{
           
            try context.save()
        }
        catch{
            print("Error ppp: \(error)")
        }
        tableView.reloadData()
        
    }
    
//    func loadItems(){
//
//        if let data = try? Data(contentsOf: dataFilePath!){
//
//            let decoder = PropertyListDecoder()
//
//
//        do{
//            itemArray = try decoder.decode([Item].self, from: data) //????
//        }
//        catch{
//            print("Task could not be loaded: \(error)")
//            }
//
//        }
//    }
    

  
    
}

