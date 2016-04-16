//
//  TWShareUtility.m
//
//  Created by DesenGuo on 2016-03-09.
//

#import <Foundation/Foundation.h>
#import "TWShareUtility.h"

@implementation TWShareUtility

+ (void)postToTwitterFromViewController:(UIViewController*)target
                        withInitialText:(NSString *)initialText
                           andURLString:(NSString *)urlString
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:initialText];
        [tweetSheet addURL:[NSURL URLWithString:urlString]];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
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
        [target presentViewController:tweetSheet animated:YES completion:nil];
    }
}

@end