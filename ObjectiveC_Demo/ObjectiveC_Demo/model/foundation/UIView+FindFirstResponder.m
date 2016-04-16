//
//  UIView+FindFirstResponder.m
//
//  Created by DesenGuo on 2016-03-14.
//

#import <Foundation/Foundation.h>
#import "UIView+FindFirstResponder.h"
@implementation UIView (FindFirstResponder)
- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}
@end