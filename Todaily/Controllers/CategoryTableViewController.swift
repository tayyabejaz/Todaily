//
//  CategoryTableViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 24/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeCellViewController {
    
    //Creating a New Realm
    let realm = try! Realm()
    
    //Category Array
    var categoryArray: Results<Category>?
    
    
    
    //First Function to run
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "FFFFF0")
        cell.textLabel?.textColor = ContrastColorOf(UIColor.randomFlat, returnFlat: true)
        return cell
    }
    
    //MARK: Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            // Saving a New Items
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //Saving Categories Function
    func saveCategories(category : Category) {
        
            do{
                try realm.write {
                    realm.add(category)
                }
            }
            catch
            {
                print("ERROR SAVING CONTEXT \(error)")
            }
            tableView.reloadData()
        }
    
    //Data Loading Methods
    func loadCategories()
    {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        if let deleteCategory = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deleteCategory)
                }
            }
            catch
            {
                print("Error in Deleting the Category \(error)")
            }

        }
    }
}

