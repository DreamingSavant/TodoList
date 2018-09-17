//
//  ViewController.swift
//  Todoey
//
//  Created by Roderick Presswood on 9/13/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    let itemArray = ["Find Mike","Buy Eggos","Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
                
                tableView.deselectRow(at: indexPath, animated: true)
        }
//        tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks add item button on UIAlert
            print("Success")
            
            alert.addTextField(configurationHandler: { (alertTextField) in
                alertTextField.placeholder = "What do ya wanna add?"
                alert.addAction(action)
            })
//            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//    }
    
    
}

