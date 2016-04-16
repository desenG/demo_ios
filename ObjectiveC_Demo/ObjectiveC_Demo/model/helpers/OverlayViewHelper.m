//
//  OverlayViewHelper.m
//  DIVE2
//
//  Created by DesenGuo on 2016-03-10.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import <Foundation/Foundation.h>
#import "OverlayViewHelper.h"

static OverlayViewHelper *_sharedInstance;
@implementation OverlayViewHelper
{
    UIView* webViewHoster;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [OverlayViewHelper new];
    });
    return _sharedInstance;
}

-(void) addwebViewToViewController:(UIViewController*) target
                        withGifURL:(NSURL *)GifURL
                          andFrame:(CGRect)frame
{
    // get your window screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //create a new view with the same size
    webViewHoster= [[UIView alloc] initWithFrame:screenRect];
    // change the background color to black and the opacity to 0.6
    webViewHoster.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    CGRect webFrame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
    UIWebView* webView=[[UIWebView alloc] initWithFrame: webFrame];
    // add this new view to your main view
    [target.view addSubview:webViewHoster];
    webView.center=webViewHoster.center;
    [webView loadRequest:[NSURLRequest requestWithURL:GifURL]];
    [webViewHoster addSubview:webView];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removewebViewHoster)];
    [webViewHoster addGestureRecognizer:singleFingerTap];
}

-(void) removewebViewHoster
{
    [webViewHoster removeFromSuperview];
    
}




@end