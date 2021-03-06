//
//  ViewController.swift
//  Todoey
//
//  Created by Amit Virani on 3/4/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.categoryCellColor {
            title = selectedCategory!.categoryName
            updateNavBarUI(withHexCode: colorHex)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBarUI(withHexCode: "1D9BF6")
    }
    
    //MARK : Nav Bar UI Setup method
    func updateNavBarUI(withHexCode colorHex: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar not available")}
        guard let navBarColor = UIColor(hexString: colorHex) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
        searchBar.tintColor = navBarColor
        
    }
    
    //MARK - Tabble view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = (item.done == true) ? .checkmark : .none
            if let colorString  = UIColor(hexString: selectedCategory!.categoryCellColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                
                cell.backgroundColor = colorString
                cell.textLabel?.textColor = ContrastColorOf(colorString, returnFlat: true)
            }
            
        }else {
            cell.textLabel?.text = "No Item Available"
        }
        
        //  cell.textLabel?.text = item?.name ?? "No Item Available"
        //ternary operator
        //value = condition ? valueIfTrue : valueIffalse
        //   cell.accessoryType = (item?.done)! ? .checkmark : .none
        return cell
    }
    
    //MARK - Table view Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try   realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error updating the done item.")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks add item button the ui alert
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.name = textField.text!
                        newItem.done = false
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
            }
            
            //uisng core data
            //                //singleton object
            //
            //                let newItem = Item(context: self.context )
            //                newItem.title = item
            //                newItem.done = false
            //                newItem.parentCategory = self.selectedCategory
            //                self.itemArray.append(newItem)
            //
            //                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //                //with property list encoder
            //                self.savaItems()
            
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
    func savaItems(newItem : Item) {
        do {
            try realm.write {
                realm.add(newItem)
            }
        }catch {
            print("Error writing items to realm\(error)")
        }
        
        
        
        //using core data
        //        do {
        //            try context.save()
        //        }catch {
        //            print(error)
        //        }
        tableView.reloadData()
    }
    //using core data:
    //method with default parameters
    //    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
    //
    //        //using NSCoding
    //        //        if let data = try? Data(contentsOf: dataFilePath!){
    //        //            let decoder = PropertyListDecoder()
    //        //            do {
    //        //                itemArray = try decoder.decode([Item].self, from: data)
    //        //            } catch {
    //        //                print("can not decode")
    //        //            }
    //        //        }
    //
    //        //using CoreData
    //
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //        if let newPredicate = predicate {
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,newPredicate])
    //        }else {
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
    //        }
    //
    //
    //
    //        do {
    //            itemArray =  try context.fetch(request)
    //        }catch {print("Error fetching Data from context:\(error)") }
    //        tableView.reloadData()
    //    }
    
    //Mark : Using realm
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
    }
    //Table View Delegate Methods
    override func updateModel(at indexpath: IndexPath) {
        if let itemToBeDeleted = todoItems?[indexpath.row] {
            do {
                try realm.write {
                    realm.delete(itemToBeDeleted)
                    
                }
            }catch {
                print("Can not delete object")
            }
        }
        tableView.reloadData()
    }
    
}
//MARK : - Search bar delegate methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //using realm
        
        todoItems = todoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true )
        
        
        tableView.reloadData()
        
        //using core data
        //        //creating a fetch request
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        //querying the fetch request
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //        //sorting the result
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //        loadItems(with: request,with:  predicate)
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
