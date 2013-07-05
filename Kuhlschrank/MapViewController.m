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
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 48.878335;
    zoomLocation.longitude = 2.384588;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*kMeterPerMile, 1*kMeterPerMile);
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    Location *myself = [[Location alloc] initWithName:@"Votre position" Address:@"19, Rue du Plateau 75019 - Paris" Coordinate:zoomLocation];
    
    [self.mapView addAnnotation:myself];
    
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView setCenterCoordinate:zoomLocation];
    
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

@end
