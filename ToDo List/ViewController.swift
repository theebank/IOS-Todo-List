//
//  ViewController.swift
//  ToDo List
//
//  Created by Theeban Kumaresan on 2021-02-11.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var items = [String]()//collection of items
    
    //tableview component
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        return table
    }()
    //returns number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //inserts a cell to insert at a given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
        
    }
    
    //ui components
    override func viewDidLoad() {
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        super.viewDidLoad()
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    //deleting items via swipe to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            items.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            table.reloadData()
            UserDefaults.standard.setValue(items, forKey: "items")
        }
    }
    //sets frame of table to entirety of view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame=view.bounds
    }
    
    //Functionality to add button
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter New item to do!", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {field in field.placeholder = "Enter Item..."})
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async{
                        var currentitems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentitems.append(text)
                        UserDefaults.standard.setValue(currentitems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                
                }
            }
        }))
        
        
        present(alert,animated: true)
    }

}

