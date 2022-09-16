//
//  ViewController.swift
//  doDone
//
//  Created by Ekrem Alkan on 15.09.2022.
//

import UIKit

class DoDoneViewController: UITableViewController {

    var toDoArray = ["ekrem", "fatih"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - verileri satırlara ekleme

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoDoneItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoArray[indexPath.row]
        
          
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
      
        }
    
    
    //MARK: - Add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Unutmamak için listeye ekle!", message: "", preferredStyle: .alert)
       
        alert.addTextField { (textField) in
            textField.placeholder = "örn: Alışveriş"
            alertTextField = textField
            
            
           }
        
        
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: {
            (action: UIAlertAction!) in
            
            self.toDoArray.append(alertTextField.text!)
            self.tableView.reloadData()
            
            
        }))
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
  
    
    
       
                
    }
    
    





