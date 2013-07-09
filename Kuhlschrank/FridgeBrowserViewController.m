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
    
    [self orderProducts];
}

- (void) orderProducts
{
    NSMutableArray * d = [[NSMutableArray alloc] init];
    NSMutableArray * m = [[NSMutableArray alloc] init];
    NSMutableArray * v = [[NSMutableArray alloc] init];
    NSMutableArray * c = [[NSMutableArray alloc] init];
    
    for (Product * prod in self.products)
    {
        if (prod.idCategory == 1)
            [d addObject:prod];
        
        if (prod.idCategory == 2)
            [m addObject:prod];
        
        if (prod.idCategory == 3)
            [v addObject:prod];
        
        if (prod.idCategory == 4)
            [c addObject:prod];
    }
    
    self.drinks = [NSMutableArray arrayWithArray:d];
    self.milkProducts = [NSMutableArray arrayWithArray:m];
    self.vegetables = [NSMutableArray arrayWithArray:v];
    self.carnivor = [NSMutableArray arrayWithArray:c];
    
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.drinks.count;
    }
    else if(section == 1)
    {
        return self.milkProducts.count;
    }
    else if (section == 2)
    {
        return self.vegetables.count;
    }
    else if (section == 3)
    {
        return self.carnivor.count;
    }
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Boissons";
    }
    else if(section == 1)
    {
        return @"Produits laitiers";
    }
    else if (section == 2)
    {
        return @"Légumes";
    }
    else if (section == 3)
    {
        return @"Viandes";
    }
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            Product *product = [self.drinks objectAtIndex:indexPath.row];
            cell.textLabel.text = product.Libelle;
        }
            break;
        case 1:
        {
            Product *product = [self.milkProducts objectAtIndex:indexPath.row];
            cell.textLabel.text = product.Libelle;
        }
            break;
        case 2:
        {
            Product *product = [self.vegetables objectAtIndex:indexPath.row];
            cell.textLabel.text = product.Libelle;
        }
            break;
        case 3:
        {
            Product *product = [self.carnivor objectAtIndex:indexPath.row];
            cell.textLabel.text = product.Libelle;
        }
            break;
        default:
            break;
    }
    
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
    
    if (result.count != 0)
    {
        ApplicationUser *usr = [result objectAtIndex:0];
        User * user = [[User alloc] init];
    
        user.ID = usr.idUser;
        user.Nom = usr.nom;
        user.Prenom = usr.prenom;
        user.Mail = usr.mail;
        user.Password = @"*********";
    
        return user;
    }
    
    return nil;
}

@end
