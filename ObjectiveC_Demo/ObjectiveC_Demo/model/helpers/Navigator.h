//
//  Navigator.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import <Foundation/Foundation.h>

@interface Navigator : NSObject
+(UIViewController *)getCurrentTopViewController;

+(void)goToRootViewController:(UIViewController*)viewController
                 withAnimated:(BOOL)Animated;

+(void)openIntialViewControllerAsNewRoot;

+(void)openViewControllerAsNewRootWithIDName:(NSString*)VCIDname;

+(void)openViewControllerAsNewRootFromViewController:(UIViewController*)viewController
                                          withIDName:(NSString*)VCIDname;

+(void)presentViewControllerWithIDName:(NSString*)VCIDname
                    fromViewController:(UIViewController*)superViewController
                          withAnimated:(BOOL)Animated;

+(void)pushViewControllerFromCurrentViewController:(UIViewController*)currentViewController
                          withViewControllerIDName:(NSString*)VCIDname
                                       andAnimated:(BOOL)Animated;

+(void)popFromViewController:(UIViewController*)viewController
                withAnimated:(BOOL)Animated;
@end
