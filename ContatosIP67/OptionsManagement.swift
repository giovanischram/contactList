//
//  OptionsManagement.swift
//  ContatosIP67
//
//  Created by ios6584 on 11/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class OptionsManagement: NSObject {
    
    private var contact: Contact
    private var controller: UIViewController!
    
    init(contact: Contact) {
        self.contact = contact
    }

    func show(controller: UIViewController) {
        self.controller = controller
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let callAction = UIAlertAction(title: "Ligar", style: .default) { (UIAlertAction) in
            let device = UIDevice.current
            if (device.model == "iPhone") {
                self.openURL(url: "tel:\(self.contact.telephone)")
            } else {
                self.showCallAltertWarning()
            }
        }
        
        let mapAction = UIAlertAction(title: "Ver no mapa", style: .default) { (UIAlertAction) in
            self.openURL(url: ("http://maps.google.com/maps?q=" + self.contact.address).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
        
        let siteAction = UIAlertAction(title: "Acessar site", style: .default) { (UIAlertAction) in
            self.openURL(url: "http://\(self.contact.site)")
        }
        
        let alert = UIAlertController(title: contact.name, message: nil, preferredStyle: .actionSheet)
        alert.addAction(cancelAction)
        alert.addAction(callAction)
        alert.addAction(mapAction)
        alert.addAction(siteAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func openURL(url: String) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    func showCallAltertWarning() {
        let alertWarnig = UIAlertController(title: "Ops", message: "Este dispositivo não permite fazer ligações.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertWarnig.addAction(okAction)
        self.controller.present(alertWarnig, animated: true, completion: nil)
    }
}
