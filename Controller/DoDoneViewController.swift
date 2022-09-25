//
//  ViewController.swift
//  doDone
//
//  Created by Ekrem Alkan on 15.09.2022.
//

import UIKit
import CoreData
import SwipeCellKit


class DoDoneViewController: UITableViewController , UISearchBarDelegate, SwipeTableViewCellDelegate {
  
    

    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoArray = [DoDoneList]()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .systemYellow
        tableView.rowHeight = 90
        
        self.getItems()
        
    }
    
    
    //MARK: - buttons

    
    
    @IBAction func sortButton(_ sender: Any) {
        self.toDoArray.sort(by: {$0.textFieldText! < $1.textFieldText!})
        self.saveItems()
        
    }
    
    //MARK: - SwipeCell

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "İptal Et") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.toDoArray[indexPath.row])
         
            self.saveItems()
            self.getItems()
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "TrashIcon")

        return [deleteAction]
    } 
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        
        return options
    }

    //MARK: - verileri satırlara ekleme

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
   
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoDoneItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
     
        let item = toDoArray[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: toDoArray[indexPath.row].createdTime!)
       
       
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = item.textFieldText
        cell.detailTextLabel?.text = dateString
        
        
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

       toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "secondVC") as! DetailViewController
        
        vc.baslik = toDoArray[indexPath.row].textFieldText!
        vc.detail = toDoArray[indexPath.row].textFieldDetailText!
        present(vc, animated: true)
        
        
        
        
        
        
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
        var alertTextFieldDetail = UITextField()
        
        let alert = UIAlertController(title: "Unutmamak için listeye ekle!", message: "", preferredStyle: .alert)
       
        alert.addTextField { (textField) in
            textField.placeholder = "örn: Pazar Alışverişi"
            alertTextField = textField
            
            
           }
        
        alert.addTextField(){ (textField) in
            textField.placeholder = "örn: Elma 2kg"
            alertTextFieldDetail = textField
            
            
           }
        
        
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: {
            (action: UIAlertAction!) in
            
            let newItem = DoDoneList(context:  self.context)
            newItem.textFieldText = alertTextField.text!
            newItem.textFieldDetailText = alertTextFieldDetail.text!
            newItem.createdTime = Date()
            newItem.done = false
            
            
            
            self.toDoArray.append(newItem)
            
            self.saveItems()
            
            
        }))
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - SearchBar Set Up
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<DoDoneList> = DoDoneList.fetchRequest()
        
        let pred = NSPredicate(format: "textFieldText CONTAINS[cd] %@", searchBar.text!)
       
        request.predicate = pred
        
        
        do {
           
            toDoArray =  try context.fetch(request)
            
        }
        catch {
            print("error = can not searched in coreData array")
        }
        
        
        
        
        tableView.reloadData()
        
    
        
        searchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
    
            let request : NSFetchRequest<DoDoneList> = DoDoneList.fetchRequest()
            
            do {
               
                toDoArray =  try context.fetch(request)
                
            }
            catch {
                print("error = can not searched in coreData array")
            }
            
            tableView.reloadData()
        }
        
        
    }
    
    //MARK: - Dismiss Keyboard while scrolling

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.keyboardDismissMode = .onDrag
    }
    
    
    
    
 
    }




    





