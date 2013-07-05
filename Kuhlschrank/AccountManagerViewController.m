//
//  AccountManagerViewController.m
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "User.h"
#import "VariableStore.h"

@interface AccountManagerViewController ()

@end

@implementation AccountManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uniqueIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
    
    self.nameLabel.text = [[VariableStore sharedInstance] currentUser].Nom;
    self.firstNameLabel.text = [[VariableStore sharedInstance] currentUser].Prenom;
    self.mailLabel.text = [[VariableStore sharedInstance] currentUser].Mail;
    self.passwordLabel.text = [[VariableStore sharedInstance] currentUser].Password;
    self.ButtonLabel.font = [UIFont fontWithName:@"System Bold" size:15.0];
    
    [self DrawButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField canResignFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)RegisterDevice:(id)sender {
    User *user = [[VariableStore sharedInstance] currentUser];
    NSString *type = [UIDevice currentDevice].model;
    
    Service * service = [VariableStore sharedInstance].service;
    
    if (self.modeInsert)
        [service RegisterDevice:type IdentifiedBy:self.uniqueIdentifier ForUser:user.ID];
    else
        [service DeleteDevice:self.uniqueIdentifier];
    
    [self DrawButton];
}

- (void) DrawButton
{
    if ([[[VariableStore sharedInstance] service] CheckRegistrationForUser:[[VariableStore sharedInstance] currentUser].ID AndDevice:self.uniqueIdentifier])
    {
        self.ButtonLabel.textColor = [UIColor redColor];
        self.ButtonLabel.text = @"Supprimer cet appareil";
        self.modeInsert = NO;
    }
    else
    {
        self.ButtonLabel.textColor = [UIColor blackColor];
        self.ButtonLabel.text = @"Enregistrer cet appreil";
        self.modeInsert = YES;
    }
}
@end
