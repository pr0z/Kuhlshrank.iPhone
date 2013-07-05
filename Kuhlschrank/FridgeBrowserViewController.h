#import <UIKit/UIKit.h>
#import "Service.h"
#import "Product.h"

@interface FridgeBrowserViewController : UITableViewController

@property NSInteger numberOfCategories;
@property (strong, nonatomic) NSMutableArray *products;

@end

