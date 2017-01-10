//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var siteTextField: UITextField!
    
    private var isNewContact: Bool = true
    private var contact: Contact?
    private var delegate: ContactTableViewControllerDelegate?
    
    var contactDao: ContactDao!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contactDao = ContactDao.currentInstance()
    }
    
    func setContact(contact: Contact) {
        self.contact = contact
        self.isNewContact = false
    }
    
    func setDelegate(delegate: ContactTableViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        if (!isNewContact) {
            nameTextField.text = contact!.name
            telephoneTextField.text = contact!.telephone
            addressTextField.text = contact!.address
            siteTextField.text = contact!.site
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addContact() {
        let contact = createContact()
        if (isNewContact) {
            saveContact(contact: contact)
        } else {
            editContact()
        }
        _ = self.navigationController?.popViewController(animated: true)
        
//        let contacts = contactDao.findAll()
//        print("Contatos salvos: \(contacts.count)")
//        for contact in contacts {
//            print(contact)
//        }
        
    }
    
    func createContact() -> Contact {
        return Contact(name: nameTextField.text!, andTelephone: telephoneTextField.text!, andAddress: addressTextField.text!, andSite: siteTextField.text!)
    }
    
    func saveContact(contact: Contact) {
        contactDao.save(contact: contact)
        delegate?.setAsInserted(contact: contact)
    }
    
    func editContact() {
        contact!.name = nameTextField.text!
        contact!.telephone = telephoneTextField.text!
        contact!.address = addressTextField.text!
        contact!.site = siteTextField.text!
        delegate?.setAsUpdated(contact: contact!)
    }
}
