//
//  ViewController.swift
//  Todoey
//
//  Created by Roderick Presswood on 9/13/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    //init new realm
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    //Used for coreData constant below
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    //NSCoder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//userdefaults code below
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //NSCoder
        print(dataFilePath!)
       
//        let newItem = Item()
//        newItem.title = "Hello World!"
//        toDoItems.append(newItem)
        
        //UserDefaults again below
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            toDoItems = items
//        }
        
//        loadItems(with: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //code constant "cell" below makes a cell its own and not reusable like the ones above^^^
        
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
             cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        
        //code below is shortened version of commented out if statement below
        
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
            try realm.write {
                
                item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "What are you going Todo?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            print(textField.text as Any)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date.init()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items. \(error)")
                }
            }
            
           self.tableView.reloadData()
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.toDoItems.append(newItem)
            
            
//            self.tableView.reloadData()
            
            //setting up core data below
            //saving items to program using userdefaults
//            self.defaults.set(self.toDoItems, forKey: "TodoListArray")
//           self.saveItems()
//            self.tableView.reloadData()
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:  nil)
        
        
    }
    //two items below correspond to NSCoder
//    func saveItems() {
//        //NSCoder start
////        let encoder = PropertyListEncoder()
//        do{
//            //core data below
//            try context.save()
//            //NsCoder code commented out
////            let data = try encoder.encode(self.toDoItems)
////            try data.write(to: self.dataFilePath!)
//        } catch {
//            print("Error saving context: \(error)")
//        } //NScoder end
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

          tableView.reloadData()
    }
    
    
}
// MARK: - SearchBar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title Contains[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
            }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
       
        loadItems()
        tableView.reloadData()
    }
}
