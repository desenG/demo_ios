//
//  ShareHelper.m
//  DIVE2
//
//  Created by DesenGuo on 2016-03-08.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareHelper.h"
@implementation ShareHelper

+(void)shareFromViewController: (UIViewController*)target
        withTextObject:(NSString *)textObject
              andURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSArray *activityItems = [NSArray arrayWithObjects:textObject, url,  nil];
    
    //-- initialising the activity view controller
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePrint,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo];
    
    [target presentViewController:activityVC animated:YES completion:nil];
    
    [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            NSLog(@"completed: %@, \n%d, \n%@, \n%@,", activityType, completed, returnedItems, activityError);
    
    }
     ];
}

-(void)shareFromViewController: (UIViewController*)target
                      withPath: (NSString *)path
{
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        UIDocumentInteractionController * documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        documentController.delegate = self;

    
        [documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:target.view animated:YES];
}

@end