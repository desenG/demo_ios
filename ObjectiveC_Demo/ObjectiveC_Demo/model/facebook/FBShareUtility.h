//
//  FBShareUtility.h
//  FacebookHelper
//
//  Created by DesenGuo on 2016-03-07.
//

#ifndef FBShareUtility_h
#define FBShareUtility_h
#import "Alert.h"
#import <Social/Social.h>
#import "FBSharedAnimation.h"

@interface FBShareUtility : NSObject

+ (void)postToFacebookFromViewController:(UIViewController*)target
                         withInitialText:(NSString *)initialText
                            andURLString:(NSString *)urlString;
+ (void)postToFacebookFromViewController:(UIViewController*)target
                         withInitialText:(NSString *)initialText
                            andURLString:(NSString *)urlString
         andShareViewPresentedCompletion:(void (^ __nullable)(void))completion;
+ (void)postToFacebookFromAppWindowWithInitialText:(NSString *)initialText
                                      andURLString:(NSString *)urlString
                   andShareViewPresentedCompletion:(void (^ __nullable)(void))completion;

+ (void)showShareDialogFromViewController:(UIViewController*)target
                            withURLString:(NSString *)urlString;
+ (void)showShareDialogFromAppWindowWithURLString:(NSString *)urlString;
@end

#endif /* FBShareUtility_h */

