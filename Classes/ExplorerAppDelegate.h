#import <UIKit/UIKit.h>

@interface ExplorerAppDelegate : NSObject <UIApplicationDelegate> {	
  IBOutlet UIWindow *window;
  IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

