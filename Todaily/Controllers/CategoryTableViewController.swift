//
//  CategoryTableViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 24/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //Category Array
    var categoryArray = [Category]()
    
    //Persistent Containers
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //Saving Categories FUnction
    func saveCategories() {
        
            do{
                try context.save()
            }
            catch
            {
                print("ERROR SAVING CONTEXT \(error)")
            }
            tableView.reloadData()
        }
    
    //Data Loading Methods
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error in fetching Categories \(error)")
        }
        tableView.reloadData()
    }
}
