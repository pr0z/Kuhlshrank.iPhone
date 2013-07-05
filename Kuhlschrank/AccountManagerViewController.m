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
    [self updateView];
    [self DrawButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) saveChanges
{
    [[[VariableStore sharedInstance] service] UpdateUserWithId:self.userId Name:self.name FirstName:self.firstName Mail:self.mail];
    
    [[[VariableStore sharedInstance] service] GetUserById:self.userId];
    [self updateView];
}

- (IBAction)updateFirstName:(id)sender {
    [self showAlertWithTitle:@"Mise à jour" Message:@"Votre prénom" Cancel:@"Annuler" Other:@"Valider" Tag:2];
}

- (IBAction)updateMail:(id)sender {
    [self showAlertWithTitle:@"Mise à jour" Message:@"Votre mail" Cancel:@"Annuler" Other:@"Valider" Tag:2];
}

- (IBAction)updateName:(id)sender {
    [self showAlertWithTitle:@"Mise à jour" Message:@"Votre nom" Cancel:@"Annuler" Other:@"Valider" Tag:1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
        self.name = [[alertView textFieldAtIndex:0] text];
    
    if (alertView.tag == 2)
        self.firstName = [[alertView textFieldAtIndex:0] text];
    
    if (alertView.tag == 3)
        self.mail = [[alertView textFieldAtIndex:0] text];
    
    [self saveChanges];
}

-(void) showAlertWithTitle:(NSString *)title Message:(NSString *)msg Cancel:(NSString *)cancel Other:(NSString *)other Tag:(int)tag
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancel otherButtonTitles:other, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    
    [alert show];
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

- (void) updateView
{
    self.userId = [[VariableStore sharedInstance] currentUser].ID;
    self.name = [[VariableStore sharedInstance] currentUser].Nom;
    self.firstName = [[VariableStore sharedInstance] currentUser].Prenom;
    self.mail = [[VariableStore sharedInstance] currentUser].Mail;
    
    self.nameLabel.text = self.name;
    self.firstNameLabel.text = self.firstName;
    self.mailLabel.text = self.mail;
    self.passwordLabel.text = [[VariableStore sharedInstance] currentUser].Password;
    self.ButtonLabel.font = [UIFont fontWithName:@"System Bold" size:15.0];
}
@end
