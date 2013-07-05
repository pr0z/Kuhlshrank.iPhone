//
//  Service.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Service : NSObject

@property NSString * url;

- (BOOL) LoginWithLogin:(NSString*)login AndPassword:(NSString*)password;
- (NSArray *) GetProductList;
- (BOOL) CheckRegistrationForUser:(NSNumber *) userId AndDevice:(NSString *) deviceIdentifier;
- (NSArray *) GetSupermarketWithLatitude:(NSString *)lat AndLongitude:(NSString *)lon;
- (void) RegisterDevice:(NSString *) type IdentifiedBy:(NSString *) uId ForUser:(NSNumber *) userId;
- (void) DeleteDevice:(NSString *) uid;

@end
