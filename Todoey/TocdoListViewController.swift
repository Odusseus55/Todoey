//
//  ViewController.swift
//  Todoey
//
//  Created by Matyas Mihalka on 14/10/2018.
//  Copyright © 2018 Matyas Mihalka. All rights reserved.
//

import UIKit
import RealmSwift

class TocdoListViewController: UITableViewController {

    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //        Ternary operator
            //        value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error savng done status")
            }
        }
        tableView.reloadData()
    
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when the user tapps the Add Item button
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error during saving new Item: \(error)")
                }
            }
            self.tableView.reloadData()
            }
        
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
//        func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil)
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK: - Model manipulation items
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error during saving context: \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TocdoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searchbar clicked")


        let filterArg = searchBar.text!
//        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", filterArg).sorted(byKeyPath: "title", ascending: true)
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", filterArg).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //[cd] - the search function will be case insensitive
//        //The result title shuld contain the word what the user typed in the searchbar
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //The result should come back in an abc order
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

