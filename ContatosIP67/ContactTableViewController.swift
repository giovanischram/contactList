//
//  ContactTableViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController, ContactTableViewControllerDelegate {
    
    // Identificador para garantir que as celular instaciadas sejam sempre válidas
    // A string 'cell' está setada no 'identifier' do 'Atributes Inspector' da tableViewCell no storyboard
    private static let CELL_IDENTIFIER: String = "cell"
    
    private static let MAIN_STORYBOARD: String = "Main"
    private static let FORM_IDENTIFIER: String = "contactForm"
    private static let CONTACT_LIST_IDENTIFIER: String = "addSegue"
    
    var contactDao: ContactDao!
    var selectedRow: IndexPath?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contactDao = ContactDao.currentInstance()
    }
    
    //Quantidade de colunas
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Quantidade de linhas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDao.count()
    }
    
    // Conteúdo de cada uma das linhas
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contactDao.findByIndex(index: indexPath.row)
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ContactTableViewController.CELL_IDENTIFIER)
        cell?.textLabel?.text = contact.name
        return cell!
    }
    
    // Recarregar tabela sempre que voltar para a tela
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        if selectedRow != nil {
            self.tableView.selectRow(at: selectedRow, animated: true, scrollPosition: .middle)
            
            // Voltar o backgroung padrao da linha depois de X segundos assincronamente
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.tableView.deselectRow(at: self.selectedRow!, animated: true)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            contactDao.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactDao.findByIndex(index: indexPath.row)
        let sotryBoard = UIStoryboard(name: ContactTableViewController.MAIN_STORYBOARD, bundle: nil)
        let form =  sotryBoard.instantiateViewController(withIdentifier: ContactTableViewController.FORM_IDENTIFIER) as! ContactFormViewController
        form.setContact(contact: contact)
        form.setDelegate(delegate: self)
        self.navigationController?.pushViewController(form, animated: true)
    }
    
    // Define o delegate quando vier do botão Adicionar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == ContactTableViewController.CONTACT_LIST_IDENTIFIER) {
            let form =  segue.destination as! ContactFormViewController
            form.setDelegate(delegate: self)
        }
    }
    
    func setAsUpdated(contact: Contact) {
        let index = contactDao.getIndex(contact: contact)
        selectedRow = IndexPath(row: index, section: 0)
    }
    
    func setAsInserted(contact: Contact) {
        let index = contactDao.getIndex(contact: contact)
        selectedRow = IndexPath(row: index, section: 0)
    }
}
