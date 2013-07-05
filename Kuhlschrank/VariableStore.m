//
//  VariableStore.m
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import "VariableStore.h"
#import "AppDelegate.h"

@implementation VariableStore
+ (VariableStore *)sharedInstance
{
    static VariableStore * myInstance = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (nil == myInstance) {
        myInstance = [[[self class] alloc] init];
        myInstance.isConnected = false;
        myInstance.service = [[Service alloc] init];
        myInstance.database = appDelegate.managedObjectContext;
    }
    
    return myInstance;
}
@end
