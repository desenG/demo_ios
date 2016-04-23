//
//  Navigator.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import <Foundation/Foundation.h>

@interface Navigator : NSObject
+(void)openViewControllerAsNewRootFromViewController:(UIViewController*)viewController
                                          withIDName:(NSString*)VCIDname;

+(void)openViewControllerAsNewRootWithIDName:(NSString*)VCIDname;

+(void)presentViewControllerWithIDName:(NSString*)VCIDname
                    fromViewController:(UIViewController*)superViewController
                          withAnimated:(BOOL)Animated;

+(void)pushViewControllerFromCurrentViewController:(UIViewController*)currentViewController
                          withViewControllerIDName:(NSString*)VCIDname
                                       andAnimated:(BOOL)Animated;

+(void)popFromViewController:(UIViewController*)viewController
                withAnimated:(BOOL)Animated;

+(void)goToRootViewController:(UIViewController*)viewController
                 withAnimated:(BOOL)Animated;

- (UIViewController *)getParentOfViewController:(UIViewController*)viewController;

+(UIViewController *)getCurrentTopViewController;

//used in app delegate
+(void)openIntialViewControllerAsNewRootInAppDelegate;

+(void)openViewControllerAsNewRootWithIDNameInAppDelegate:(NSString*)VCIDname;

@end
