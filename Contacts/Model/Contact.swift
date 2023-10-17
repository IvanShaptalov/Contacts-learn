//
//  Contact.swift
//  Contacts
//
//  Created by van on 16.10.2023.
//

import Foundation

protocol ContactProtocol{
    
    var title: String {get set}
    
    var phone: String {get set}
    
}

struct Contact : ContactProtocol{
    var title: String
    
    var phone: String
}


// MARK: Contact Storage
protocol  ContactStorageProtocol {
    func load() -> [ContactProtocol]
    
    func save(contacts: [ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
            
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String: String]] = []
        contacts.forEach {
            contact in
            var newElementForStorage: Dictionary<String,String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
    
    private enum ContactKey: String {
        case title
        case phone
    }
    
    private var storage = UserDefaults.standard
    
    private var storageKey = "contacts"
    
    
}
