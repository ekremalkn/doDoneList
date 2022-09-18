//
//  ViewController.swift
//  doDone
//
//  Created by Ekrem Alkan on 15.09.2022.
//

import UIKit

class DoDoneViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var toDoArray = [DoDoneList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.getItems()
    }

    
    
    
    
    
    
    
    
    //MARK: - verileri satırlara ekleme

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoDoneItemCell", for: indexPath)
        
        let item = toDoArray[indexPath.row]
        
        cell.textLabel?.text = item.textFieldText
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

       toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        context.delete(toDoArray[indexPath.row])
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
       
      
        }
    
    
    //MARK: - Core Data
    
    
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("error = can not save context")
        }
        
        self.tableView.reloadData()
    }
    
    
    func getItems() {
        
        do {
           
            toDoArray =  try context.fetch(DoDoneList.fetchRequest())
            
        }
        catch {
            print("error = can not load items from coredata")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Unutmamak için listeye ekle!", message: "", preferredStyle: .alert)
       
        alert.addTextField { (textField) in
            textField.placeholder = "örn: Alışveriş"
            alertTextField = textField
            
            
           }
        
        
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: {
            (action: UIAlertAction!) in
            
            let newItem = DoDoneList(context:  self.context)
            newItem.textFieldText = alertTextField.text!
            newItem.done = false
            newItem.createdTime = Date()
            
            self.toDoArray.append(newItem)
            self.saveItems()
            
            
        }))
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
    
    
    
    
    
    
       
                
    }
    
    





