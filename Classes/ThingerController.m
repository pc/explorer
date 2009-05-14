#import "ThingerController.h"

@implementation ThingerController

@synthesize widthSlider;
@synthesize heightSlider;
@synthesize theView;

- (IBAction)dimensionsChanged {
  [theView setFrame:CGRectMake(theView.frame.origin.x, theView.frame.origin.y, widthSlider.value, heightSlider.value)];
}

- (void)setTheView:(UIView *)v {
  theView = [v retain];
  [self.view addSubview:v];
}

- (void)dealloc {
  [theView release];
  [super dealloc];
}

@end
