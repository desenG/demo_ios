//
//  SlideShowDemoViewController.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-28.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface SlideShowDemoViewController : UIViewController<KASlideShowDelegate>
@property (strong, nonatomic) IBOutlet KASlideShow *slideshowView;

@end
