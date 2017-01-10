//
//  ContactTableViewControllerDelegate.swift
//  ContatosIP67
//
//  Created by ios6584 on 10/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

protocol ContactTableViewControllerDelegate {

    func setAsUpdated(contact: Contact)
    func setAsInserted(contact: Contact)
}
