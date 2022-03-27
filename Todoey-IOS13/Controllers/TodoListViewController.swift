//
//  ViewController.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 26.03.22.
//

import UIKit
import RealmSwift


class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<RTodoItem>?
    
    var parentCategory: RCategory? {
        didSet {
            fetchItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 60.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let text = alertTextField?.text {
                alertTextField?.text = ""

                let item = RTodoItem()
                item.title = text
                self.saveItem(item)
            }
        }
        
        alert.addTextField { UITextField in
            alertTextField = UITextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            deleteItem(item)
        }
    }
    
    // MARK: - Todo items data manipulations
    
    func fetchItems(predicate: NSPredicate? = nil) {
        if let predicate = predicate {
            itemArray = parentCategory?.todoItems.filter(predicate).sorted(byKeyPath: "createdAt", ascending: true)
        } else {
            itemArray = parentCategory?.todoItems.sorted(byKeyPath: "createdAt", ascending: true)
        }

        tableView.reloadData()
    }
    
    func saveItem(_ item: RTodoItem) {
        do {
            try realm.write {
                parentCategory?.todoItems.append(item)
                realm.add(item)
            }
        } catch {
            print("Failed to save item: \(error)")
        }

        tableView.reloadData()
    }
    
    func deleteItem(_ item: RTodoItem) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
}

// MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            fetchItems(predicate: NSPredicate(format: "title CONTAINS[cd] %@", text))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty { return }

        fetchItems()

        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
