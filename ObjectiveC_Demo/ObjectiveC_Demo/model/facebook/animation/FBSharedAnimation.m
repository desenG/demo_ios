//
//  FBSharedAnimation.m
//
//  Created by DesenGuo on 2016-03-22.
//

#import <Foundation/Foundation.h>
#import "FBSharedAnimation.h"
static FBSharedAnimation *_sharedInstance;

@implementation FBSharedAnimation
{
    NSTimer *timer;
    NSInteger globalTimer;
    NSInteger counter;
    NSInteger minutesLeft;
    NSInteger secondsLeft;
    UIRefreshControl *refreshControl;
    CircularProgressTimer *progressTimerView;
    UIViewController* hostViewController;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FBSharedAnimation new];
    });
    return _sharedInstance;
}

-(void)startAnimationFromViewController:(UIViewController*)viewController
                         withCompletion:(void(^)(void))completion
{
    hostViewController=viewController;
    _complete=completion;
    globalTimer = 60;
    minutesLeft=0;
    secondsLeft=0;
    [self startTimer];
}

// Draws the progress circles on top of the already painted backgroud
- (void)drawCircularProgressBarWithMinutesLeft:(NSInteger)minutes secondsLeft:(NSInteger)seconds
{
    // Removing unused view to prevent them from stacking up
    for (id subView in [hostViewController.view subviews]) {
        if ([subView isKindOfClass:[CircularProgressTimer class]]) {
            [subView removeFromSuperview];
        }
    }
    
    // Init our view and set current circular progress bar value
    CGRect progressBarFrame = CGRectMake(0, 0, hostViewController.view.frame.size.width, hostViewController.view.frame.size.height);
    progressTimerView = [[CircularProgressTimer alloc] initWithFrame:progressBarFrame];
    [progressTimerView setCenter:hostViewController.view.center];
    [progressTimerView setPercent:60-seconds];
    // Here, setting the minutes left before adding it to the parent view
    [progressTimerView setMinutesLeft:minutesLeft];
    [progressTimerView setSecondsLeft:secondsLeft];
    [hostViewController.view addSubview:progressTimerView];
}

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                             target:self
                                           selector:@selector(updateCircularProgressBar)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)updateCircularProgressBar
{
    // Values to be passed on to Circular Progress Bar
    if (globalTimer > 0 && globalTimer <= 1200) {
        globalTimer--;
        minutesLeft = globalTimer / 60;
        secondsLeft = globalTimer % 60;
        
        [self drawCircularProgressBarWithMinutesLeft:minutesLeft secondsLeft:secondsLeft];
        NSLog(@"Time left: %02d:%02d", minutesLeft, secondsLeft);
    } else {
        [self drawCircularProgressBarWithMinutesLeft:0 secondsLeft:0];
        [timer invalidate];
        [self performSelector:@selector(runcomplete) withObject:nil afterDelay:1.0];
    }
}
-(void)runcomplete
{
    [progressTimerView removeFromSuperview];
    _complete();
}


@end