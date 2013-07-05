//
//  User.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int ID;
@property (strong, nonatomic) NSString * Mail;
@property (strong, nonatomic) NSString * Nom;
@property (strong, nonatomic) NSString * Prenom;
@property (strong, nonatomic) NSString * Password;

@end
