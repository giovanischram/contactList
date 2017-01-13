//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit
import CoreLocation

class ContactFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var siteTextField: UITextField!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var geoLocationButton: UIButton!
    @IBOutlet weak var geoLocationActivityIndicator: UIActivityIndicatorView!
    
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
            
            print("Latitude: \(contact!.latitude)")
            print("Longitude: \(contact!.longitude)")
            if let latitude = contact!.latitude {
                latitudeTextField.text = formatNumber(number: latitude)
            }
            
            if let longitude = contact!.longitude {
                longitudeTextField.text = formatNumber(number: longitude)
            }
        } else {
            photoImageView.image = #imageLiteral(resourceName: "lista-contatos")
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
        if (isNewContact) {
            let contact = createContact()
            saveContact(contact: contact)
        } else {
            editContact()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getGeolocation(_ sender: AnyObject) {
        print("Searching coordinates...")
        geoLocationButton.isHidden = true
        geoLocationActivityIndicator.startAnimating()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressTextField.text!) { (result, error) in
            if (error == nil && result!.count > 0) {
                let placeMark = result?[0]
                let coordinates = placeMark?.location?.coordinate
                print("Latitude: \(coordinates?.latitude.description)")
                print("Longitude: \(coordinates?.longitude.description)")
                self.latitudeTextField.text = coordinates?.latitude.description
                self.longitudeTextField.text = coordinates?.longitude.description
            }
            self.geoLocationButton.isHidden = false
            self.geoLocationActivityIndicator.stopAnimating()
        }
    }
    
    func createContact() -> Contact {
        var decimalLatitude = NSDecimalNumber()
        if let latitude = latitudeTextField.text {
            if (!latitude.isEmpty) {
                decimalLatitude = NSDecimalNumber(value: Double(latitude)!)
            }
        }
        
        var decimalLongitude = NSDecimalNumber()
        if let longitude = longitudeTextField.text {
            if (!longitude.isEmpty) {
                decimalLongitude = NSDecimalNumber(value: Double(longitude)!)
            }
        }
        
        let contact = contactDao.newContact();
        contact.name = nameTextField.text!
        contact.telephone = telephoneTextField.text!
        contact.address = addressTextField.text!
        contact.site = siteTextField.text!
        contact.photo = photoImageView.image!
        contact.latitude = decimalLatitude
        contact.longitude = decimalLongitude
        
        return contact
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
        
        if let latitude = latitudeTextField.text {
            contact!.latitude = NSDecimalNumber(value: Double(latitude)!)
        }
        if let longitude = longitudeTextField.text {
            contact!.longitude = NSDecimalNumber(value: Double(longitude)!)
        }
        
        contactDao.update(contact: contact!)
        delegate?.setAsUpdated(contact: contact!)
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        photoImageView.image = image
        photoImageView.backgroundColor = UIColor.clear
        picker.dismiss(animated: true, completion: nil)
    }
    
    func formatNumber(number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        return formatter.string(from: number)!
    }
}
