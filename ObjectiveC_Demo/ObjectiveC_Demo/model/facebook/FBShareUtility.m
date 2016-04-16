//
//  FBShareUtility.m
//  FacebookHelper
//
#import <Foundation/Foundation.h>
#import "FBShareUtility.h"


@interface DiveFBSDKSharingDelegate : NSObject<FBSDKSharingDelegate>
@property (copy) void (^shareHandler)(id obj, NSError * err);
+(DiveFBSDKSharingDelegate*)sharedInstance;
@end

static DiveFBSDKSharingDelegate *_sharedInstance;

@implementation DiveFBSDKSharingDelegate
{
}
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [DiveFBSDKSharingDelegate new];
    });
    return _sharedInstance;
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    if(_sharedInstance.shareHandler)
    {
        _sharedInstance.shareHandler(results,nil);
    }
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    if(_sharedInstance.shareHandler)
    {
        _sharedInstance.shareHandler(nil,error);
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    if(_sharedInstance.shareHandler)
    {
        _sharedInstance.shareHandler(nil,nil);
    }
}
@end

@implementation FBShareUtility

+ (void)postToFacebookFromViewController:(UIViewController*)target
                         withInitialText:(NSString *)initialText
                            andURLString:(NSString *)urlString
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:initialText];
        [facebookSheet addURL:[NSURL URLWithString:urlString]];
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        [target presentViewController:facebookSheet animated:YES completion:nil];
    }
    else
    {
        
    }
}

+ (void)postToFacebookFromViewController:(UIViewController*)target
                         withInitialText:(NSString *)initialText
                            andURLString:(NSString *)urlString
         andShareViewPresentedCompletion:(void (^ __nullable)(void))completion
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:initialText];
        [facebookSheet addURL:[NSURL URLWithString:urlString]];
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        [target presentViewController:facebookSheet animated:YES completion:completion];
    }
    else{
        
    }
}

+ (void)postToFacebookFromAppWindowWithInitialText:(NSString *)initialText
                                      andURLString:(NSString *)urlString
                   andShareViewPresentedCompletion:(void (^ __nullable)(void))completion
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:initialText];
        [facebookSheet addURL:[NSURL URLWithString:urlString]];
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        UIWindow* appWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        appWindow.rootViewController= [[UIViewController alloc] init];
        [appWindow makeKeyAndVisible];
        [appWindow.rootViewController presentViewController:facebookSheet animated:YES completion:completion];
    }
    else
    {
        
    }
}

+ (void)showShareDialogFromViewController:(UIViewController*)target
                            withURLString:(NSString *)urlString
{
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeWeb;
    dialog.fromViewController = target;
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlString];
    //    content.imageURL = [NSURL URLWithString:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
    //    content.contentTitle = @"Name: Facebook News Room";
    //    content.contentDescription = @"Description: The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.";
    // placeID is hardcoded here, see https://developers.facebook.com/docs/graph-api/using-graph-api/#search for building a place picker.
    //    content.placeID = @"166793820034304";
    dialog.shareContent = content;
    dialog.shouldFailOnDataError = YES;
    [FBShareUtility shareDialog:dialog];
}
static UIWindow *appWindow;

+ (void)showShareDialogFromAppWindowWithURLString:(NSString *)urlString
{
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeWeb;
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlString];
    //    content.imageURL = [NSURL URLWithString:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
    //    content.contentTitle = @"Name: Facebook News Room";
    //    content.contentDescription = @"Description: The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.";
    // placeID is hardcoded here, see https://developers.facebook.com/docs/graph-api/using-graph-api/#search for building a place picker.
    //    content.placeID = @"166793820034304";
    dialog.shareContent = content;
    dialog.shouldFailOnDataError = YES;
    appWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    appWindow.rootViewController= [[UIViewController alloc] init];
    [appWindow makeKeyAndVisible];
    dialog.fromViewController = appWindow.rootViewController;
    
    NSError *error;
    if (![dialog validateWithError:&error]) {
        UIAlertController* _alertController = [Alert alertControllerWithTitle:@"Invalid share content" message:@"Error validating share content"];
        [dialog.fromViewController presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    if (![dialog show]) {
        UIAlertController* _alertController = [Alert alertControllerWithTitle:@"Invalid share content" message:@"Error opening dialog"];
        [dialog.fromViewController presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    DiveFBSDKSharingDelegate* diveFBSDKSharingDelegate=[DiveFBSDKSharingDelegate sharedInstance];
    diveFBSDKSharingDelegate.shareHandler=^(id obj, NSError *err){
        NSLog(@"%@",obj);
        if(!obj) return;
        [[FBSharedAnimation sharedInstance] startAnimationFromViewController:dialog.fromViewController withCompletion:^{
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        }];
    };
    [dialog setDelegate:diveFBSDKSharingDelegate];
    
}

+ (void)shareDialog:(FBSDKShareDialog *)dialog
{
    NSError *error;
    if (![dialog validateWithError:&error]) {
        UIAlertController* _alertController = [Alert alertControllerWithTitle:@"Invalid share content" message:@"Error validating share content"];
        [dialog.fromViewController presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    if (![dialog show]) {
        UIAlertController* _alertController = [Alert alertControllerWithTitle:@"Invalid share content" message:@"Error opening dialog"];
        [dialog.fromViewController presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    DiveFBSDKSharingDelegate* diveFBSDKSharingDelegate=[DiveFBSDKSharingDelegate sharedInstance];
    diveFBSDKSharingDelegate.shareHandler=^(id obj, NSError *err){
        NSLog(@"%@",obj);
        if(!obj) return;
        [[FBSharedAnimation sharedInstance] startAnimationFromViewController:dialog.fromViewController withCompletion:^{
        }];
    };
    [dialog setDelegate:diveFBSDKSharingDelegate];
}


@end
