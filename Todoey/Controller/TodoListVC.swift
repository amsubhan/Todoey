//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 2018-03-19.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
            tableView.rowHeight = 80.0
        }
    }
    var selectedColour : UIColor?
    
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //print(dataFilePath!)
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            print("flag 1")
//            itemArray = items
//        }
      
//     loadItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        //called after viewDidLoad but just before user sees anything!
        
        guard let color = selectedCategory?.bgColor else{fatalError()}
        
        title = selectedCategory?.name
        updateNavBar(withHexCode: color)
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9bf6")
    }
    
    //MARK: - Navbar setup
    func updateNavBar(withHexCode colourHexCode :String){
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navugation Controller does not exist")
        }
        guard let barColor = UIColor(hexString: colourHexCode) else{fatalError()}
        //                let barColor = FlatWhite()
        navBar.barTintColor = barColor
        navBar.tintColor = ContrastColorOf(barColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(barColor, returnFlat: true)]
        searchBar.barTintColor = barColor
    }
    
    //MARK - TabelView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
//            print("dsdd-----------------")
//            let clr  = item.parentCategory.value(forKey: "bgColor")
//            print(clr )
            
            
      
            
            if let colour = UIColor(hexString : selectedCategory!.bgColor)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            {
             cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        
        else{
            cell.textLabel?.text = "No Items to show, please add some!"
        }
        
    
        return cell
    }

    //MARK - TableView Delegate Methods
    
    //methods to get data/listen from UI
    
    //listen when row is selected!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
       // tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }a
        
        tableView.deselectRow(at: indexPath, animated: true) // ????
    }
    
    //MARK - Add new Todo items
    

    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //when user click add btn
//            print(textField.text)
            
            if let currentCategory = self.selectedCategory{
                do{
//                    let date = Date()
//                    let formatter = DateFormatter()
//
//                    formatter.dateFormat = "dd.MM.yyyy"
//                    print("________________________________")
//                    print(formatter.string(from: date))
                    
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() //formatter.string(from: date)
                        currentCategory.itemsObjects.append(newItem)
                    }
                    print("Data Saved")
                }
                catch{
                    print("Error ppp: \(error)")
                }
            }
            
            
            
                    

            self.tableView.reloadData()
            //print(self.todoItems[self.todoItems.count - 1])
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manuplation Methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemDeletion = self.todoItems?[indexPath.row]{
            do{
                try   self.realm.write {
                    self.realm.delete(itemDeletion)
                }
            }catch{
                print("Error removing category \(error)")
            }
        }
        //            tableView.reloadData() comment b/c of expansion styles
        
    }
   
    func loadItems(){
        
        todoItems = selectedCategory?.itemsObjects.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    


  
    
}

//MARK: - Search bar methods
extension TodoListVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData() 

    }

      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if (searchBar.text!.count == 0){
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }

            }
        }
}

