//
//  Contact.h
//  ContatosIP67
//
//  Created by ios6584 on 09/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Contact : NSObject<MKAnnotation>

@property NSString *name;
@property NSString *telephone;
@property NSString *address;
@property NSString *site;
@property UIImage *photo;
@property NSNumber *latitude;
@property NSNumber *longitude;

-(instancetype) initWithName: (NSString*) name
                andTelephone: (NSString*) telephone
                andAddress: (NSString*) address
                andSite: (NSString*) site
                andPhoto: (UIImage*) photo
                andLatitude: (NSNumber*) latitude
                andLongitude: (NSNumber*) longitude;

@end
