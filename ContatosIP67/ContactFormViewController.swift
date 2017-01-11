//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var siteTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
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
            photoImageView.image = contact!.photo
        } else {
            let url = URL(string: "http://store.mdcgate.com/market/assets/image/icon_user_default.png")
            let data:Data = try! Data(contentsOf: url!)
            photoImageView.image = UIImage(data: data)
        }
        
        self.photoImageView.layer.cornerRadius = 60.0
        self.photoImageView.clipsToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showLibrary(gesture:)))
        self.photoImageView.addGestureRecognizer(gesture)
    }
    
    func showLibrary(gesture: UIGestureRecognizer) {
        let imageController = UIImagePickerController()
        imageController.allowsEditing = true
        imageController.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            print("Has comera")
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
                imageController.sourceType = .camera
                self.present(imageController, animated: true, completion: nil)
            }
            
            let libraryAction = UIAlertAction(title: "Galeria", style: .default) { (UIAlertAction) in
                imageController.sourceType = .photoLibrary
                self.present(imageController, animated: true, completion: nil)
            }
            
            let alert = UIAlertController(title: "Selecione", message: nil, preferredStyle: .actionSheet)
            alert.addAction(cancelAction)
            alert.addAction(cameraAction)
            alert.addAction(libraryAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            print("Do not have comera")
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true, completion: nil)
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
        return Contact(name: nameTextField.text!, andTelephone: telephoneTextField.text!, andAddress: addressTextField.text!, andSite: siteTextField.text!, andPhoto: photoImageView.image!)
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
        contact!.photo = photoImageView.image!
        delegate?.setAsUpdated(contact: contact!)
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        photoImageView.image = image
        photoImageView.backgroundColor = UIColor.clear
        picker.dismiss(animated: true, completion: nil)
    }
}
