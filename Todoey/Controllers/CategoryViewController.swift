//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Amit Virani on 3/5/19.
//  Copyright © 2019 Amit Virani. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        for text in categoryArray{
            print(text.name!)
        }
    }
    
    //MARK : - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
           
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextField.text!
            
            self.saveData()
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Category Name"
            newCategoryTextField = categoryTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK : Table view Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:"categoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryArray.count
    }
    
    //MARK : Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch { print("error loading category:\(error)") }
        
        
        tableView.reloadData()
    }
    func saveData(){
        do {
            try  context.save()
        } catch {print("error saving category:\(error)") }
        
        tableView.reloadData()
    }
    
}
