//
//  ViewController.swift
//  Todoey
//
//  Created by Nguyen Trung Kien on 9/29/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArrays = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }


    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArrays[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays.count
    }
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemCell = itemArrays[indexPath.row]
        itemCell.done = !itemCell.done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert?
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArrays.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model Manipulation Method
 
    func saveItems() {
        let encoder = PropertyListEncoder()
        if let dataEncoded = try? encoder.encode(self.itemArrays) {
            do {
                try dataEncoded.write(to: self.dataFilePath!)
            } catch {
                print("Error when encoding \(error)")
            }
        }
        tableView.reloadData()
    }
    
    
    func loadItems() {
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            itemArrays = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error when decoding \(error)")
        }
    }
}

