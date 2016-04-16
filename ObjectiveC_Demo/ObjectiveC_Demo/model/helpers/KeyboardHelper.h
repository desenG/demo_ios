//
//  KeyboardHelper.h
//
//  Created by DesenGuo on 2016-03-14.
//
#import "UIView+FindFirstResponder.h"

#ifndef KeyboardHelper_h
#define KeyboardHelper_h
@interface KeyboardHelper:NSObject
-(void)addKeyboardShowAndHideObserverToViewController:(UIViewController*) target;
-(void)removeKeyboardShowAndHideObserver;
@end

#endif /* KeyboardHelper_h */
