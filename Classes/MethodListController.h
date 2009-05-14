#import <UIKit/UIKit.h>
#import "ThingerController.h"

@interface MethodListController : UIViewController <UITableViewDataSource> {
  NSArray *instanceMethods, *classMethods, *ivars, *protocols;
  NSString *cls;
  id theCls;
  IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSArray *instanceMethods, *classMethods, *ivars, *protocols;
@property (nonatomic, retain) NSString *cls;
@property (nonatomic, retain) UITableView *tableView;

@end
