//
//  ViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 17/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    //Item Array
    var itemArray = [Item]()
    
    var selectedCategory : Category?
    {
        didSet
        {
            loadData()
        }
    }
    
    //User Default Data
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //print(dataFilePath!)
        
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Using a Ternary Operator
        // value = condition ? valueIfTrue : ValueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Toggle the Checkmark Sign
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Item Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New ToDo Alert", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation Method
    //Using a CoreData Methods
    func saveItems()
    {
        do{
           try context.save()
        }
        catch
        {
            print("ERROR SAVING CONTEXT \(error)")
        }
        self.tableView.reloadData()
    }
    
    //Decoding the data from Plist to show on the array
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil)
    {
        //Older method using Plist and Decode and Encode Methods
//            if let data = try? Data(contentsOf: dataFilePath!)
//            {
//                do{
//                    let decoder = PropertyListDecoder()
//                    itemArray = try  decoder.decode([Item].self , from: data)
//
//                }
//                catch
//                {
//                    print("Error in Decoding data \(error)")
//                }
//                }
        
        // New Method using Database and CRUD
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSCompoundPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error in fetching the Error. \(error)")
        }
        
        }
}

extension TableViewController : UISearchBarDelegate
{
    //Adding a Search Bar Delegatge Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
