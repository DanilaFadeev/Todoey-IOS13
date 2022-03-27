//
//  CategoryListViewController.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 27.03.22.
//

import UIKit
import RealmSwift

class CategoryListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<RCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60.0
        fetchCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        var alertTextField: UITextField?
        alert.addTextField { UITextField in alertTextField = UITextField }
        
        alert.addAction(
            UIAlertAction(title: "Add", style: .default) { UIAlertAction in
                if let text = alertTextField?.text {
                    let category = RCategory()
                    category.name = text
                    self.saveCategory(category)
                }
            }
        )
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.ItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoListVC = segue.destination as! TodoListViewController
        todoListVC.parentCategory = categories?[tableView.indexPathForSelectedRow!.row]
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            deleteCategory(category)
        }
    }
    
    // MARK: - Category data manipulations
    
    func fetchCategories() {
        categories = realm.objects(RCategory.self)
        tableView.reloadData()
    }
    
    func saveCategory(_ category: RCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category to Realm: \(error)")
        }

        tableView.reloadData()
    }
    
    func deleteCategory(_ category: RCategory) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
}
