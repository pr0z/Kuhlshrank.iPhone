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
	// Do any additional setup after loading the view.
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
    
    NSLog(@"%@", type);
    
    NSString * uniqueId = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"%@", uniqueId);
    
    [[[VariableStore sharedInstance] service] CheckRegistrationForUser:user.ID AndDevince:uniqueId];
    
}
@end
