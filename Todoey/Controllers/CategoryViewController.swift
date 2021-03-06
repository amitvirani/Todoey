//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Amit Virani on 3/5/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        
        
        
    }
    
    //MARK : - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            
            let newCategory = Category()
            newCategory.categoryName = newCategoryTextField.text!
            newCategory.categoryCellColor = UIColor.randomFlat.hexValue()
            
            
            self.saveData(newCategory: newCategory)
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Category Name"
            newCategoryTextField = categoryTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    //MARK : Table view Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.categoryName ?? "No category available"
        cell.backgroundColor = UIColor(hexString: category!.categoryCellColor)
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category!.categoryCellColor)!, returnFlat: true)
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK : Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //TableView Delegate Methods
    override func updateModel(at indexpath: IndexPath) {
        if let categoryToBeDeleted = categoryArray?[indexpath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToBeDeleted)
                    
                }
            }catch {
                print("Can not delete object")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: Data Manipulation Methods
    func loadData() {
        //        do {
        //            categoryArray = try context.fetch(request)
        //        } catch { print("error loading category:\(error)") }
        //
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    func saveData(newCategory: Category){
        //        do {
        //            try  context.save()
        //        } catch {print("error saving category:\(error)") }
        
        do {
            try realm.write {
                realm.add(newCategory)
            }
        }catch {
            print("Error")
        }
        
        tableView.reloadData()
    }
    
    
}


