#import <UIKit/UIKit.h>

@interface ThingerController : UIViewController {
  IBOutlet UISlider *widthSlider;
  IBOutlet UISlider *heightSlider;
  UIView *theView;
}

@property (nonatomic, retain) UISlider *widthSlider;
@property (nonatomic, retain) UISlider *heightSlider;
@property (nonatomic, retain) UIView *theView;

- (IBAction)dimensionsChanged;

@end
