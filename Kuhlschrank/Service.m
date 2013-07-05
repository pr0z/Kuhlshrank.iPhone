//
//  Service.m
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import "Service.h"
#import "VariableStore.h"
#import "Product.h"
#import "ApplicationUser.h"
#import "Location.h"

#define kWebServiceUrl @"http://192.168.1.42:9999"
#define kPlaceApiUrlBegin @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=";
#define kPlaceApiUrlEnd @"&radius=500&types=grocery_or_supermarket&sensor=false&key=AIzaSyBoDh_b1KLF61ir3l28C8CIi3x07ZR-gpY";

@implementation Service

- (id) init
{
    self.url = kWebServiceUrl;
    
    return self;
}

- (BOOL) LoginWithLogin:(NSString*)login AndPassword:(NSString*)password
{
    NSString * loginUrl = self.url;
    NSString * params = [NSString stringWithFormat:@"/User.svc/fromIAndP?i=%@&p=%@", login, password];
    loginUrl = [loginUrl stringByAppendingString:params];
                
    id jsonAnswer = [self GetJsonAnswerWithUrl:loginUrl];
    
    if (jsonAnswer == nil)
        return false;
    
    User * user = [[User alloc] init];
    user.ID = [NSNumber numberWithInt:[[jsonAnswer objectForKey:@"ID"] intValue]];
    user.Mail = [jsonAnswer objectForKey:@"Mail"];
    user.Nom = [jsonAnswer objectForKey:@"Nom"];
    user.Prenom = [jsonAnswer objectForKey:@"Prenom"];
    user.Password = [jsonAnswer objectForKey:@"Password"];
    
    [VariableStore sharedInstance].currentUser = user;
    
    NSManagedObjectContext * db = [[VariableStore sharedInstance] database];
    
    ApplicationUser * appUser = (ApplicationUser *)[NSEntityDescription insertNewObjectForEntityForName:@"ApplicationUser" inManagedObjectContext:db];
    
    appUser.idUser = user.ID;
    appUser.mail = user.Mail;
    appUser.nom = user.Nom;
    appUser.prenom = user.Prenom;
    appUser.isLogged = [NSNumber numberWithInt:1];
    
    [db save:nil];
    
    return true;
}

- (NSArray *) GetProductList
{
    NSString * webUrl = [self.url stringByAppendingString:@"/Product.svc/getall"];
    
    id jsonAnswer = [self GetJsonAnswerWithUrl:webUrl];
    
    NSMutableArray * products = [[NSMutableArray alloc] init];
    
    for (NSDictionary * prod in jsonAnswer)
    {
        Product *product = [[Product alloc] init];
        product.ID = [[prod objectForKey:@"ID"] intValue];
        product.Libelle = [prod objectForKey:@"Libelle"];
        
        [products addObject:product];
    }
    
    return products;
}


- (NSArray *) GetSupermarketWithLatitude:(NSString *)lat AndLongitude:(NSString *)lon
{
    NSString *currentLocation =[NSString stringWithFormat:@"%@,%@",lat,lon];
    NSString *baseUrl = kPlaceApiUrlBegin;
    NSString *endUrl = kPlaceApiUrlEnd;
    NSString *urlWithParams = [baseUrl stringByAppendingFormat:@"%@",currentLocation];
    baseUrl = [urlWithParams stringByAppendingString:endUrl];
    
    id jsonAnswer = [self GetJsonAnswerWithUrl:baseUrl];
    jsonAnswer = [jsonAnswer objectForKey:@"results"];
    
    NSMutableArray *markets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *market in jsonAnswer)
    {
        NSString* name = [market objectForKey:@"name"];
        NSString* address = [market objectForKey:@"vicinity"];
        
        id geometry = [market objectForKey:@"geometry"];
        id location = [geometry objectForKey:@"location"];
        NSString* lat = [location objectForKey:@"lat"];
        NSString* lng = [location objectForKey:@"lng"];
        
        CLLocationCoordinate2D marketLocation;
        marketLocation.latitude = [lat floatValue];
        marketLocation.longitude = [lng floatValue];
        
        Location *aMarket = [[Location alloc] initWithName:name Address:address Coordinate:marketLocation];
        
        [markets addObject:aMarket];
    }
    
    return markets;
}

- (BOOL) CheckRegistrationForUser:(NSNumber *)userId AndDevice:(NSString *)deviceIdentifier
{
    NSString * webUrl = [self.url stringByAppendingString:[NSString stringWithFormat:@"/Device.svc/checkFromIandU?i=%@&u=%i", deviceIdentifier, [userId integerValue]]];
    
    id jsonAnswer = [self GetJsonAnswerWithUrl:webUrl];
    
    return [jsonAnswer boolValue];
}


- (void) RegisterDevice:(NSString *) type IdentifiedBy:(NSString *) uId ForUser:(NSNumber *) userId
{
    NSString * baseUrl = [self.url stringByAppendingFormat:@"/Device.svc/registerDevice?type=%@&uid=%@&userId=%i", type, uId, [userId integerValue]];
    
    [self GetJsonAnswerWithUrl:baseUrl];
}


- (void) DeleteDevice:(NSString *) uid
{
    NSString * baserUrl = [self.url stringByAppendingFormat:@"/Device.svc/deleteDevice?uid=%@", uid];
    [self GetJsonAnswerWithUrl:baserUrl];
}

- (id) GetJsonAnswerWithUrl:(NSString *) webUrl
{
    webUrl = [webUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:webUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    id jsonAnswer;
    
    if (data != nil){
        jsonAnswer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return jsonAnswer;
    }
    else
        return nil;
}
@end