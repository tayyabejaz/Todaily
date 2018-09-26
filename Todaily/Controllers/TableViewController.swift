//
//  ViewController.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 17/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TableViewController: SwipeCellViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        guard let colourHEX = selectedCategory?.color else{fatalError("Selected Category COlor Property Not Found")}
        updateNavBar(withHexCode: colourHEX)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1FB6DE")
    }
    
    //MARK:- Updating the Navbar
    func updateNavBar(withHexCode ColorHex : String) {
        guard let navbar = navigationController?.navigationBar else {fatalError("Navigation COntroller Doesn't Exists")}
        guard let navbarColor = UIColor(hexString: ColorHex) else{fatalError("Error in Getting a Navbar Colour")}
        navbar.barTintColor = navbarColor
        navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
        searchBar.barTintColor = navbarColor
        title = selectedCategory!.name
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / (CGFloat)(itemArray!.count))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
                        newitem.createdDate = Date()
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
    func loadData()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    override func updateDataModel(at indexPath: IndexPath)
    {
        if let deleteItem = self.itemArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deleteItem)
                }
            }
            catch
            {
                print("Error in Deleting the Category \(error)")
            }
            
        }
        
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
