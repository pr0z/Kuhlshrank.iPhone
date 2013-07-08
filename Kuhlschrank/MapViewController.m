//
//  MapViewController.m
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"
#import "VariableStore.h"
#define kMeterPerMile 1609.344

extern const CLLocationAccuracy kCLLocationAccuracyBest;

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    self.myLocationManager.delegate = self;
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.myLocationManager startUpdatingLocation];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.myLocation.coordinate.latitude;
    zoomLocation.longitude = self.myLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*kMeterPerMile, 1*kMeterPerMile);
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView setCenterCoordinate:zoomLocation];
    [self.mapView regionThatFits:viewRegion];
    
    NSString* lat = [NSString stringWithFormat:@"%f", zoomLocation.latitude];
    NSString* lon = [NSString stringWithFormat:@"%f", zoomLocation.longitude];
    
    [self PlaceSupermarketsWithLatitude:lat AndLongitude:lon];
}

- (void) PlaceSupermarketsWithLatitude:(NSString *)lat AndLongitude:(NSString *)lon
{
    NSArray * markets =
    [[[VariableStore sharedInstance] service] GetSupermarketWithLatitude:lat AndLongitude:lon];
    
    for (Location* market in markets)
        [self.mapView addAnnotation:market];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.myLocation = currentLocation;
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = self.myLocation.coordinate.latitude;
        zoomLocation.longitude = self.myLocation.coordinate.longitude;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*kMeterPerMile, 1*kMeterPerMile);
        
        [self.mapView setRegion:viewRegion animated:YES];
        [self.mapView setCenterCoordinate:zoomLocation];
        [self.mapView regionThatFits:viewRegion];
        
        NSString* lat = [NSString stringWithFormat:@"%f", zoomLocation.latitude];
        NSString* lon = [NSString stringWithFormat:@"%f", zoomLocation.longitude];
        
        [self PlaceSupermarketsWithLatitude:lat AndLongitude:lon];
    }
}
@end
