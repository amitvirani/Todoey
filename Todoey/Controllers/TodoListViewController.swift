//
//  ViewController.swift
//  Todoey
//
//  Created by Amit Virani on 3/4/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        loadItems()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - Tabble view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        //ternary operator
        //value = condition ? valueIfTrue : valueIffalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Table view Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        savaItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks add item button the ui alert
            print("Success!")
            if let item = textField.text {
                //singleton object
                
                let newItem = Item(context: self.context )
                newItem.title = item
                newItem.done = false
                self.itemArray.append(newItem)
                
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                //with property list encoder
                self.savaItems()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelledAction) in
            print("Cancelled")
        }
        //adding text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MEARK - Data Manipulation Methods
    func savaItems() {
        do {
            try context.save()
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        //using NSCoding
        //        if let data = try? Data(contentsOf: dataFilePath!){
        //            let decoder = PropertyListDecoder()
        //            do {
        //                itemArray = try decoder.decode([Item].self, from: data)
        //            } catch {
        //                print("can not decode")
        //            }
        //        }
        
        //using CoreData
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray =  try context.fetch(request)
        }catch {print("Error fetching Data from context:\(error)") }
        
        
    }
    
}
//MARK : - Search bar delegate methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        searchBar.text = ""
    }
}
