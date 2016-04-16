//
//  FBSharedAnimation.h
//
//  Created by DesenGuo on 2016-03-22.
//

#ifndef FBSharedAnimation_h
#define FBSharedAnimation_h
#import "CircularProgressTimer.h"
@interface FBSharedAnimation:NSObject
+(FBSharedAnimation*)sharedInstance;
-(void)startAnimationFromViewController:(UIViewController*)viewController
                         withCompletion:(void(^)(void))completion;
@property (copy) void (^complete)(void);
@end
#endif /* FBSharedAnimation_h */
