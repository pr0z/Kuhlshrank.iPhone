#import <UIKit/UIKit.h>
#import "Service.h"
#import "Product.h"

@interface FridgeBrowserViewController : UITableViewController <UITableViewDelegate>

@property NSInteger numberOfCategories;
@property (strong, nonatomic) NSMutableArray * drinks;
@property (strong, nonatomic) NSMutableArray * milkProducts;
@property (strong, nonatomic) NSMutableArray * vegetables;


@property (strong, nonatomic) NSMutableArray *products;

@end

