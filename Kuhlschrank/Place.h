//
//  Place.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 05/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * nom;

@end
