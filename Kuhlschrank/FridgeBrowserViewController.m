//
//  BrowserTableViewController.m
//  Kuhlschrank
//
//  Created by Roman Leichnig on 04/07/13.
//  Copyright (c) 2013 Roman Leichnig. All rights reserved.
//

#import "FridgeBrowserViewController.h"
#import "VariableStore.h"
#import "AppDelegate.h"
#import "ApplicationUser.h"

@interface FridgeBrowserViewController ()

@end

@implementation FridgeBrowserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self clearTable];
    
    bool firstLogin = [self checkFirstConnection];
    
    if (firstLogin)
        if (![[VariableStore sharedInstance] isConnected])
            [self showLoginView];
        
    [VariableStore sharedInstance].currentUser = [self GiveUser];
    
    self.products = [NSMutableArray arrayWithArray:[[[VariableStore sharedInstance] service] GetProductList]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = [product.Libelle stringByAppendingString:@" x1"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)showLoginView
{
    UIAlertView * login = [[UIAlertView alloc] initWithTitle:@"Kühlschrank" message:@"Veuillez vous identifier" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Valider", nil];
    login.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [login show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        [self showLoginView];
    
    NSString * login = [[alertView textFieldAtIndex:0] text];
    NSString * password = [[alertView textFieldAtIndex:1] text];
    
    [VariableStore sharedInstance].isConnected = [[[VariableStore sharedInstance]service] LoginWithLogin:login AndPassword:password];
    
    if (![[VariableStore sharedInstance] isConnected])
        [self showLoginView];
}

-(BOOL) checkFirstConnection
{
    NSFetchRequest * query = [[NSFetchRequest alloc]  initWithEntityName:@"ApplicationUser"];
    NSArray * result = [[[VariableStore sharedInstance] database] executeFetchRequest:query error:nil];
    
    if (result.count == 0)
        return true;
    
    id first = [result objectAtIndex:0];
    if (((ApplicationUser *) first).isLogged == [NSNumber numberWithInt:1])
        return false;
    else
        return true;
}

-(void) clearTable
{
    NSFetchRequest * query = [[NSFetchRequest alloc]  initWithEntityName:@"ApplicationUser"];
    NSArray * users = [[[VariableStore sharedInstance] database] executeFetchRequest:query error:nil];
    
    for (ApplicationUser *user in users)
        [[[VariableStore sharedInstance] database] deleteObject:user];
}

- (User *) GiveUser
{
    NSFetchRequest * query = [[NSFetchRequest alloc]  initWithEntityName:@"ApplicationUser"];
    NSArray * result = [[[VariableStore sharedInstance] database] executeFetchRequest:query error:nil];
    
    ApplicationUser *usr = [result objectAtIndex:0];
    User * user = [[User alloc] init];
    
    user.ID = usr.idUser;
    user.Nom = usr.nom;
    user.Prenom = usr.nom;
    user.Mail = usr.mail;
    user.Password = @"*********";
    
    return user;        
}

@end
