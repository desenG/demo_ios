//
//  SlideShowDemoViewController.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-28.
//

#import "SlideShowDemoViewController.h"

@implementation SlideShowDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initKASlideshowView];
}

-(void)initKASlideshowView
{
    // KASlideshow
    _slideshowView.delegate = self;
    [_slideshowView setDelay:1]; // Delay between transitions
    [_slideshowView setTransitionDuration:1]; // Transition duration
    [_slideshowView setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)
    [_slideshowView addGesture:KASlideShowGestureSwipe];
    [_slideshowView setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshowView addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources
    [_slideshowView addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
    [_slideshowView start];
}

#pragma mark - KASlideShow delegate

- (void)kaSlideShowWillShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void)kaSlideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) kaSlideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidNext, index : %@",@(slideShow.currentIndex));
}

-(void)kaSlideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidPrevious, index : %@",@(slideShow.currentIndex));
}

@end
