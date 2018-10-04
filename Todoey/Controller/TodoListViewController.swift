//
//  ViewController.swift
//  Todoey
//
//  Created by Roderick Presswood on 9/13/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    //Used for coreData constant below
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
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
//        itemArray.append(newItem)
        
        //UserDefaults again below
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems(with: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //code constant "cell" below makes a cell its own and not reusable like the ones above^^^
        
        let item = itemArray[indexPath.row]
        
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        cell.textLabel?.text = item.title
        
        //code below is shortened version of commented out if statement below
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //code above is the same at commented if-else statement below
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        saveItems()
        tableView.reloadData()
//            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//                tableView.deselectRow(at: indexPath, animated: true)
//            } else {
//                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//
//                tableView.deselectRow(at: indexPath, animated: true)
//        }
//        tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "What are you going Todo?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            print(textField.text as Any)
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            
            //setting up core data below
            
            
            //saving items to program using userdefaults
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
           self.saveItems()
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
        
    }
    //two items below correspond to NSCoder
    func saveItems() {
        //NSCoder start
//        let encoder = PropertyListEncoder()
        do{
            //core data below
            try context.save()
            //NsCoder code commented out
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error saving context: \(error)")
        } //NScoder end
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
//
//        request.predicate = compoundPredicate
        
        do {
            
            itemArray = try context.fetch(request)
       
        } catch {
            
            print("Error fetching data from context: \(error)")
            
        }
        

    }
    
    
}
// MARK: - SearchBar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // format key on realm website
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        searchBar.showsCancelButton = true
       loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            searchBar.resignFirstResponder()
            tableView.reloadData()
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
