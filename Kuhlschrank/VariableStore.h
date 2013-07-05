//
//  VariableStore.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Service.h"

@interface VariableStore : NSObject

@property BOOL isConnected;
@property (strong, nonatomic) User * currentUser;
@property (strong, nonatomic) Service *service;
@property (strong, nonatomic) NSManagedObjectContext * database;

+ (VariableStore *)sharedInstance;

@end
