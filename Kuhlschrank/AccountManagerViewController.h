//
//  AccountManagerViewController.h
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManagerViewController : UIViewController <UITextFieldDelegate>

- (IBAction)RegisterDevice:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegistrationButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString * uniqueIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *ButtonLabel;
@property BOOL modeInsert;

@end
