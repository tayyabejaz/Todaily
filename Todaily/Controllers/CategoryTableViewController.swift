//
//  CategoryTableViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 24/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added Yet"
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
}
