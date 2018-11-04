//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roderick Presswood on 10/2/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    // init new realm
    let realm = try! Realm()
    var categories: Results<Category>?
//    var categoryArray: Results<Category>
//
    // CoreData constants below
    
    
    
//    let request: NSFetchRequest<Category> = Category.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        //func below used to load saved items
//      loadItems(with: request)
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added"
        return cell
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "What name will you use to organize your notes?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(textField.text as Any)
            
            let newCategory = Category()
            newCategory.name = textField.text!
            //newCategory.done = false
            
            
            
            self.saveItems(Category: newCategory)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveItems(Category: Category){
        
        do{
            try realm.write {
                realm.add(Category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
//
    func loadItems(){
         categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    //MARK: - TableView Delegate Methods leave for later
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
         destinationVC.navigationItem.title = categories?[indexPath.row].name
        }
    }

}
