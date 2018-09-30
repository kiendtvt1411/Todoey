//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nguyen Trung Kien on 9/30/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArrays = [Category]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadCategories()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldAlert = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textFieldAlert.text!
            
            self.categoryArrays.append(category)
            self.saveCategories()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category here..."
            textFieldAlert = textField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArrays[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrays.count
    }
    
    
    // MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationMVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationMVC.selectedCategory = categoryArrays[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArrays = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}
