//
//  ViewController.swift
//  ToDoList
//
//  Created by Khaled Rahman-Ayon on 03.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var addTextFeild: NSTextField!
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteBtn: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    func fetchData() {
        //get the data from the coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                //Set the data into class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
            } catch {}
            
            //update the table...
            tableView.reloadData()
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        if addTextFeild.stringValue != "" {
            
            let appDelegate = NSApplication.shared().delegate as? AppDelegate
            if let context =  appDelegate?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = addTextFeild.stringValue
                if importantCheckBox.state == 0 {
                    //Not important
                    toDoItem.important = false
                    
                } else {
                    //It's Important
                    toDoItem.important = true
                    
                }
                
            }
            
            //Save CoreData
            appDelegate?.saveAction(nil)
            //Reseting the field and the checkbox
            addTextFeild.stringValue = ""
            importantCheckBox.state = 0
            
            //after the new item has been add to the core data
            fetchData()
        }
    }
    
    //Delete Button Action to delete a row
    @IBAction func deleteClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(toDoItem)
            
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            fetchData()
            
            deleteBtn.isHidden = true
        }
        
        
    }
    
    // MARK: - TableView Setup
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == "importantColumn" {
            //Important Column
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "‼️"
                } else {
                    cell.textField?.stringValue = ""
                }
                
                
                return cell
            }
        } else {
            //Todo Name Column
            if let cell = tableView.make(withIdentifier: "toDoName", owner: self) as? NSTableCellView {
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
            
        }
        
        return nil
    }
    
    //selection of tableView 
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
    
}

