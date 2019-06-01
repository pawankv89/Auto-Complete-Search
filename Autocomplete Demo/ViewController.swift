//
//  ViewController.swift
//  Autocomplete Demo
//
//  Created by Pawan kumar on 19/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var task: UITextField!
    @IBOutlet weak var messageBox: UILabel!
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    var PLM = PlistFileManager()
    var taskList = [String]()
    var autocompleteWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PLM.createPlistFile(fileName: "Tasks.plist")
        taskList = PLM.fetchData(fileName: "Tasks.plist")
        task.delegate = self
        
        print("taskList:-\(taskList)")
        
        autocompleteTableView.isHidden = true
        autocompleteTableView.backgroundColor = UIColor(red: 0.00, green: 0.25, blue: 0.50, alpha: 1.00)
        
        //Register Cell
        autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        autocompleteTableView.dataSource = self
        autocompleteTableView.delegate = self
        
    }
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        task.resignFirstResponder()
        autocompleteTableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        task.resignFirstResponder()
        
        if task.text!.isEmpty {
            messageBox.text = "Task required."
            return
        }
        
        if taskExistsOnFile() == true {
            messageBox.text = "Sorry, that task already exists on file."
        } else if saveTask() == true {
            messageBox.text = "Task saved."
        }
    }
    
    func taskExistsOnFile() -> Bool {
        var taskFound = false
        taskList = PLM.fetchData(fileName: "Tasks.plist")
        
        if taskList.count > 0 {
            let predicate : NSPredicate = NSPredicate(format: "SELF LIKE[c] %@", task.text!)
            let searchResults = taskList.filter {predicate.evaluate(with: $0)}
            if searchResults.count > 0 {
                taskFound = true
            }
        }
        
        return taskFound
    }
    
    func saveTask() -> Bool {
        
        var taskSaved = false
        taskList.append(task.text!)
        let taskArray = taskList as NSArray
        taskSaved = PLM.saveData(fileName: "Tasks.plist", tasks: taskArray)
        
        return taskSaved
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        autocompleteWords.removeAll(keepingCapacity: false)
        messageBox.text = nil
        let predicate : NSPredicate = NSPredicate(format: "SELF contains %@", textField.text!)
        let searchResults = taskList.filter {predicate.evaluate(with: $0)}
        
        if searchResults.count == 0 {
            autocompleteTableView.isHidden = true
        } else {
            for task in searchResults {
                autocompleteWords.append(task)
            }
            
            autocompleteTableView.isHidden = false
            autocompleteTableView.reloadData()
        }
        
        return true
    }
}

extension ViewController {
    
    // MARK: - Table View data source and delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor(red: 0.00, green: 0.25, blue: 0.50, alpha: 1.00)
        cell.textLabel!.textColor = UIColor.orange
        cell.textLabel!.text = autocompleteWords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        task.text = selectedCell.textLabel!.text
        task.resignFirstResponder()
        autocompleteTableView.isHidden = true
    }
}

