//
//  Contact.m
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

#import "Contact.h"

@implementation Contact

NSString *name;
NSString *telephone;
NSString *address;
NSString *site;

-(instancetype) initWithName: (NSString*) name
           andTelephone: (NSString*) telephone
             andAddress: (NSString*) address
                andSite: (NSString*) site
               andPhoto: (UIImage*) photo {
    
    Contact *contact = [Contact new];
    contact.name = name;
    contact.telephone = telephone;
    contact.address = address;
    contact.site = site;
    contact.photo = photo;
    return contact;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@, Endereço: %@, Site: %@", self.name, self.telephone, self.address, self.site];
}

@end
