//
//  CategoryListViewController.swift
//  Todoey-IOS13
//
//  Created by Daniil Demidovich on 27.03.22.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        var alertTextField: UITextField?
        alert.addTextField { UITextField in alertTextField = UITextField }
        
        alert.addAction(
            UIAlertAction(title: "Add", style: .default) { UIAlertAction in
                if let text = alertTextField?.text {
                    let category = Category(context: self.context)
                    category.name = text

                    self.categories.append(category)
                    self.saveCategories()
                }
            }
        )
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CategoryCell, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.ItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoListVC = segue.destination as! TodoListViewController
        todoListVC.parentCategory = categories[tableView.indexPathForSelectedRow!.row]
    }
    
    // MARK: - Category data manipulations
    
    func fetchCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categrist from context: \(error)")
        }

        tableView.reloadData()
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category context: \(error)")
        }

        tableView.reloadData()
    }
}
