//
//  AccountManagerViewController.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManagerViewController : UIViewController

- (IBAction)updateFirstName:(id)sender;
- (IBAction)updateMail:(id)sender;
- (IBAction)updateName:(id)sender;
- (IBAction)RegisterDevice:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegistrationButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString * uniqueIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *ButtonLabel;
@property BOOL modeInsert;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * mail;
@property (strong, nonatomic) NSNumber * userId;

@end
