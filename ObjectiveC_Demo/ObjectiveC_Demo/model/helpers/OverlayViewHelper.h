//
//  OverlayViewHelper.h
//  DIVE2
//
//  Created by DesenGuo on 2016-03-10.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//
#ifndef OverlayViewHelper_h
#define OverlayViewHelper_h


#endif /* OverlayViewHelper_h */
@interface OverlayViewHelper : NSObject
+(OverlayViewHelper*)sharedInstance;
-(void) addwebViewToViewController:(UIViewController*) target
withGifURL:(NSURL *)GifURL
                          andFrame:(CGRect)frame;
@end