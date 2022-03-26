//
//  ViewController.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 26.03.22.
//

import UIKit


class TodoListViewController: UITableViewController {
    
    var itemArray: [TodoItem] = [
        TodoItem(title: "Find Mike"),
        TodoItem(title: "Go to sleep"),
        TodoItem(title: "Buy gifts for family")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let text = alertTextField?.text {
                alertTextField?.text = ""
                
                self.itemArray.append(TodoItem(title: text))
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { UITextField in
            alertTextField = UITextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

