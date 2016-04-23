//
//  Navigator.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import "Navigator.h"

@implementation Navigator

+(void)openViewControllerAsNewRootFromViewController:(UIViewController*)viewController
                                          withIDName:(NSString*)VCIDname
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    [viewController.navigationController setViewControllers: [NSArray arrayWithObject: [storyboard instantiateViewControllerWithIdentifier:VCIDname ]]
                                                   animated: YES];
}

+(void)openViewControllerAsNewRootWithIDName:(NSString*)VCIDname
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UIViewController *currentRootViewController = [APPDELEGATE window].rootViewController;
    [currentRootViewController.navigationController setViewControllers: [NSArray arrayWithObject: [storyboard instantiateViewControllerWithIdentifier:VCIDname ]]
                                                   animated: YES];
}

+(void)presentViewControllerWithIDName:(NSString*)VCIDname
                    fromViewController:(UIViewController*)superViewController
                          withAnimated:(BOOL)Animated
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    [superViewController presentViewController:[storyboard instantiateViewControllerWithIdentifier:VCIDname] animated:Animated completion:^{
    }];
}

+(void)pushViewControllerFromCurrentViewController:(UIViewController*)currentViewController
                          withViewControllerIDName:(NSString*)VCIDname
                                       andAnimated:(BOOL)Animated
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    [currentViewController.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:VCIDname ] animated:Animated];
}

+(void)popFromViewController:(UIViewController*)viewController
                withAnimated:(BOOL)Animated
{
    [viewController.navigationController popViewControllerAnimated:Animated];
}

+(void)goToRootViewController:(UIViewController*)viewController
                 withAnimated:(BOOL)Animated
{
    [viewController.navigationController popToRootViewControllerAnimated:Animated];
}

- (UIViewController *)getParentOfViewController:(UIViewController*)viewController
{
    NSInteger myIndex = [viewController.navigationController.viewControllers indexOfObject:viewController];
    
    if ( myIndex != 0 && myIndex != NSNotFound ) {
        return [viewController.navigationController.viewControllers objectAtIndex:myIndex-1];
    } else {
        return nil;
    }
}

+(UIViewController *)getCurrentTopViewController
{
    UIViewController *parentViewController = [APPDELEGATE window].rootViewController;
    
    while (parentViewController.presentedViewController != nil){
        parentViewController = parentViewController.presentedViewController;
    }
    return parentViewController;
}

//used in app delegate
+(void)openIntialViewControllerAsNewRootInAppDelegate
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    APPDELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APPDELEGATE.window.rootViewController = [storyboard instantiateInitialViewController];
}

+(void)openViewControllerAsNewRootWithIDNameInAppDelegate:(NSString*)VCIDname
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    APPDELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APPDELEGATE.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:VCIDname];
}
@end
