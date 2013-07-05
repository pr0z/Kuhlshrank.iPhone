//
//  ApplicationUser.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 05/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApplicationUser : NSManagedObject

@property (nonatomic, retain) NSNumber * isLogged;
@property (nonatomic, retain) NSNumber * idUser;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSString * prenom;
@property (nonatomic, retain) NSString * mail;

@end
