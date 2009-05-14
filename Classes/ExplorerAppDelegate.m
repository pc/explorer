#import "ExplorerAppDelegate.h"
#import "ClassesController.h"

@implementation ExplorerAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}

- (void)dealloc {
  [navigationController release];
  [window release];
  [super dealloc];
}

@end
