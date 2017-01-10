//
//  ContactDao.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class ContactDao: NSObject {

    private static var instance: ContactDao!
    
    private var contacts = Array<Contact>()
    
    override private init() {
        super.init()
    }
    
    static func currentInstance() -> ContactDao {
        if (instance == nil) {
            instance = ContactDao()
        }
        return instance
    }
    
    func save(contact: Contact) {
        print("Salvando contato: \(contact)")
        contacts.append(contact)
    }
    
    func findAll() -> Array<Contact> {
        return contacts
    }
    
    func findByIndex(index: Int) -> Contact {
        return contacts[index]
    }
    
    func delete(index: Int) {
        print("Deleting contact at index \(index)")
        contacts.remove(at: index)
    }
    
    func getIndex(contact: Contact) -> Int {
        return contacts.index(of: contact)!
    }
    
    func count() -> Int {
        return contacts.count
    }
}
