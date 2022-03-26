//
//  ViewController.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 26.03.22.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [TodoItem]()
    
    var parentCategory: Category? {
        didSet {
            fetchItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TodoItemCell)!
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Delete items
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)

        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let text = alertTextField?.text {
                alertTextField?.text = ""
                
                let item = TodoItem(context: self.context)
                item.title = text
                item.parentCategory = self.parentCategory
                
                self.itemArray.append(item)
                self.saveItems()
            }
        }
        
        alert.addTextField { UITextField in
            alertTextField = UITextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Todo items data manipulations
    
    func fetchItems(predicate: NSPredicate? = nil) {
        let request = TodoItem.fetchRequest()
        do {
            if let categoryName = parentCategory?.name {
                let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
                if let predicate = predicate {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
                } else {
                    request.predicate = categoryPredicate
                }
    
                itemArray = try context.fetch(request)
            }
        } catch {
            print("Error fetching data from context: \(error)")
        }

        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
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
