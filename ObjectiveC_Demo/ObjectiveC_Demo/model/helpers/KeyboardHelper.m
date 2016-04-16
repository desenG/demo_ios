//
//  KeyboardHelper.m
//
//  Created by DesenGuo on 2016-03-14.
//

#import <Foundation/Foundation.h>
#import "KeyboardHelper.h"

@implementation KeyboardHelper
{
    UIViewController* targetVC;
}

-(void)addKeyboardShowAndHideObserverToViewController:(UIViewController*) target
{
    targetVC=target;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:targetVC.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:targetVC.view.window];
}

-(void)dismissKeyboard
{
    UIView* currentFirstResponder=targetVC.view.findFirstResponder;
    [currentFirstResponder resignFirstResponder];
}

//[textField resignFirstResponder];

-(void)removeKeyboardShowAndHideObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // Move the main view (if necessary) so that the keyboard does not hide the currentFirstResponder.
    [self scrollViewForKeyboardRaise:YES keyboardHeight:kbSize.height];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // if view was scrolled for keyboard, return the view to original position.
    [self scrollViewForKeyboardRaise:NO keyboardHeight:0];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)scrollViewForKeyboardRaise:(BOOL) keyBoardWasRaised keyboardHeight:(CGFloat) kbHeight {
    UIView* currentFirstResponder=targetVC.view.findFirstResponder;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // slide the view
    
    CGRect frame = targetVC.view.frame;
    UIScrollView* srollSuperView=[self findUIScrollViewSuperView:currentFirstResponder];
    if (keyBoardWasRaised) {
        
        CGRect responserAbsolutePos= [currentFirstResponder convertRect:currentFirstResponder.bounds toView:targetVC.view];
        float bottomY_responser=responserAbsolutePos.origin.y+responserAbsolutePos.size.height;
        
        if(bottomY_responser>kbHeight)
        {
            if(!srollSuperView)
            {
              frame.origin.y = 0-kbHeight;
            }
            else
            {
                [srollSuperView setContentSize:CGSizeMake(srollSuperView.frame.size.width, srollSuperView.frame.size.height+kbHeight)];
                [srollSuperView setContentOffset:CGPointMake(0, [srollSuperView convertPoint:CGPointZero fromView:currentFirstResponder].y - 10) animated:YES];

            }
          
        }
        else
        {
            if(!srollSuperView)
            {
                frame.origin.y=0;
            }
            else
            {
                [srollSuperView setContentSize:CGSizeMake(srollSuperView.frame.size.width, srollSuperView.frame.size.height)];                
            }
        }
    }
    else {
        frame.origin.y = 0;
    }
    
    targetVC.view.frame = frame;
    [UIView commitAnimations];
}

- (UIScrollView*)findUIScrollViewSuperView:(UIView*) view
{
    UIView *superView=view.superview;
    while(superView && ![superView isKindOfClass:[UIScrollView class]])
    {
        superView=superView.superview;
    }
    if(superView)
    {
        return (UIScrollView*)superView;
    }
    return nil;
}

@end

