//
//  ContactDao.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

class ContactDao: CoreDataUtil {

    private static var instance: ContactDao!
    
    private var contacts = Array<Contact>()
    
    override private init() {
        super.init()
        fakeContact()
        loadContacts()
    }
    
    static func currentInstance() -> ContactDao {
        if (instance == nil) {
            instance = ContactDao()
        }
        return instance
    }
    
    func newContact() -> Contact {
        return NSEntityDescription.insertNewObject(forEntityName: "Contact", into: self.persistentContainer.viewContext) as! Contact
    }
    
    func save(contact: Contact) {
        print("Saving contact: \(contact)")
        contacts.append(contact)
        self.saveContext()
    }
    
    func update(contact: Contact) {
        print("Updating contact: \(contact)")
        self.saveContext()
    }
    
    func findAll() -> Array<Contact> {
        return contacts
    }
    
    func findByIndex(index: Int) -> Contact {
        return contacts[index]
    }
    
    func delete(index: Int) {
        print("Deleting contact at index \(index)")
        let contact = contacts[index]
        self.persistentContainer.viewContext.delete(contact)
        contacts.remove(at: index)
        self.saveContext()
    }
    
    func getIndex(contact: Contact) -> Int {
        return contacts.index(of: contact)!
    }
    
    func count() -> Int {
        return contacts.count
    }
    
    private func loadContacts() {
        let fetch = NSFetchRequest<Contact>(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        do {
            self.contacts = try self.persistentContainer.viewContext.fetch(fetch)
        } catch let error as NSError {
            print("Error to fetch contacts : \(error.localizedDescription)")
        }
    }
    
    private func fakeContact() {
        let key = "alreadyOpened"
        let config = UserDefaults.standard
        let alreadyOpened = config.bool(forKey: key)
        if !alreadyOpened {
            let contact = self.newContact()
            contact.name = "João da Silva"
            contact.telephone = "11988887777"
            contact.address = "Avenida Paulista, 1100"
            contact.site = "www.joaodasilva.com.br"
            contact.photo = #imageLiteral(resourceName: "lista-contatos")
            save(contact: contact)
            config.set(true, forKey: key)
        }
    }
}
