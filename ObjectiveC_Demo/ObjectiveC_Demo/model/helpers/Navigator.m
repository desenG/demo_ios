//
//  Navigator.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import "Navigator.h"

@implementation Navigator

+(UIViewController *)getCurrentTopViewController
{
    UIViewController *parentViewController = [APPDELEGATE window].rootViewController;
    
    while (parentViewController.presentedViewController != nil){
        parentViewController = parentViewController.presentedViewController;
    }
    return parentViewController;
}

+(void)goToRootViewController:(UIViewController*)viewController
                 withAnimated:(BOOL)Animated
{
    [viewController.navigationController popToRootViewControllerAnimated:Animated];
}

+(void)openIntialViewControllerAsNewRoot
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    APPDELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APPDELEGATE.window.rootViewController = [storyboard instantiateInitialViewController];
}

+(void)openViewControllerAsNewRootWithIDName:(NSString*)VCIDname
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    APPDELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APPDELEGATE.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:VCIDname];
}

+(void)openViewControllerAsNewRootFromViewController:(UIViewController*)viewController
                                          withIDName:(NSString*)VCIDname
{
    viewController.view.window.rootViewController = [viewController.view.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:VCIDname];
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
@end
