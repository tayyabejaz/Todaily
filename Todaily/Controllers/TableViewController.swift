//
//  ViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 17/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    //Getting a Current Date
    let date = Date()
    
    
    //Creating a New Realm
    let realm = try! Realm()
    
    //Item Array
    var itemArray: Results<Item>?
    
    var selectedCategory : Category?
    {
        didSet
        {
            loadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print(date)
        
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //Using a Ternary Operator
            // value = condition ? valueIfTrue : ValueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else
        {
            cell.textLabel?.text = "No Item Added"
        }
        
        
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = itemArray?[indexPath.row]
        {
            do
            {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch
            {
                print("Error in toggling the Checkmark \(error)")
            }
        }
        
        //Toggle the Checkmark Sign
        
        //itemArray?[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Item Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            if let currentCategory = self.selectedCategory
            {
                do{
                    try self.realm.write {
                        let newitem = Item()
                        newitem.title = textField.text!
                        newitem.createdDate = self.date
                        currentCategory.items.append(newitem)                }
                }
                catch
                {
                    print("Error in Creating a Newitem in Realm \(error)")
                }
                
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation Method
    //Using a Realm Data

    
    //Decoding the data from Plist to show on the array
    func loadData()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

extension TableViewController : UISearchBarDelegate
{
    //Adding a Search Bar Delegatge Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
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
