//
//  ViewController.swift
//  Contacts
//
//  Created by van on 15.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    
    var storage: ContactStorageProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func showNewContactAlert(){
        let alertController = UIAlertController(title: "Create new Contact", message: "Enter name and phone", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in textField.placeholder = "Name"
        })
        
        alertController.addTextField(configurationHandler: {
            textField in textField.placeholder = "Phone"})
        
        let createButton = UIAlertAction(title: "Create Contact", style: .default) { _ in
            guard let contactName = alertController.textFields? [0].text else {
                return
            }
            
            guard let contactPhone = alertController.textFields?[1].text else {
                return
            }
            
            let contact = Contact(title: contactName, phone: contactPhone)
            
            self.contacts.append(contact)
            
            self.tableView.reloadData()
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Observer to sort contacts at any changes
    var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort{$0.title < $1.title}
            storage.save(contacts: contacts)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
        //userDefaults.set("Some random text", forKey: "Some key")
        
        let text = userDefaults.object(forKey: "Some key")
        
        print(text ?? "not loaded")
        
        // Do any additional setup after loading the view.
    }


}
// MARK: Loading Contact Data
extension ViewController{
    private func loadContacts(){
        contacts = storage.load()
    }
    
}


// MARK: TableView DataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") else {
        print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            var newCell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        var configuration = newCell.defaultContentConfiguration()
            configuration.text = contacts[indexPath.row].title
            
        newCell.contentConfiguration = configuration
            configure(cell: &newCell, for: indexPath)
            return newCell
        }
        
        print("Используем старую ячейку для строки с индексом \(indexPath.row)")
        
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
    if #available(iOS 14, *) {
    var configuration = cell.defaultContentConfiguration()
    configuration.text = contacts[indexPath.row].title
    configuration.secondaryText = contacts[indexPath.row].phone
    cell.contentConfiguration = configuration
    } else {
        cell.textLabel?.text = "Строка \(indexPath.row)"
    }
        
    }
    
    
}

// MARK: TableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Define available action to line \(indexPath.row)")
        let actionDelete =
        UIContextualAction(style: .destructive,
                           title: "Delete", handler:
                            {
                                _,_,_ in
                           self.contacts.remove(at: indexPath.row)
                           tableView.reloadData()
                           })
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        
        return actions
    }
}

