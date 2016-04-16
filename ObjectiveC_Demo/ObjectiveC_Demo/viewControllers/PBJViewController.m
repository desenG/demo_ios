//
//  PBJViewController.m
//  PBJVision
//
//  Created by Patrick Piemonte on 7/23/13.
//  Copyright (c) 2013-present, Patrick Piemonte, http://patrickpiemonte.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PBJViewController.h"
@implementation PBJViewController
{
    AVCaptureVideoPreviewLayer *_previewLayer;
    PBJFocusView *_focusView;
    UITapGestureRecognizer *_focusTapGestureRecognizer;
    UITapGestureRecognizer *_photoTapGestureRecognizer;
    
    BOOL _recording;
    
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
    __block NSDictionary *_currentPhoto;
    
    NSTimer *countdownTimer;
    MZTimerLabel *timer;
}

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - init

- (void)dealloc
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    _focusTapGestureRecognizer.delegate = nil;
    _photoTapGestureRecognizer.delegate = nil;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // preview and AV layer
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    [[PBJVision sharedInstance] setPresentationFrame:_previewView.frame];

    // focus view
    _focusView = [[PBJFocusView alloc] initWithFrame:CGRectZero];
    
    // tap to focus
    _focusTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleFocusTapGesterRecognizer:)];
    _focusTapGestureRecognizer.delegate = self;
    _focusTapGestureRecognizer.numberOfTapsRequired = 1;
    _focusTapGestureRecognizer.enabled = NO;
    [_previewView addGestureRecognizer:_focusTapGestureRecognizer];
    
    if ([[PBJVision sharedInstance] supportsVideoFrameRate:120]) {
        // set faster frame rate
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (IBAction)actionCapture:(id)sender {
    if(_recording)
    {
        if(timer)
        {
            [timer pause];
        }
        [self _endCapture];
    }
    else
    {
        [self _startCapture];
    }

}



#pragma mark - private start/stop helper methods

- (void)_startCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [[PBJVision sharedInstance] startVideoCapture];
    
    timer =  [[MZTimerLabel alloc] initWithLabel:_timerLabel andTimerType:MZTimerLabelTypeTimer];
    timer.timeLabel.center=_timerLabel.center;
    timer.timeLabel.font = [UIFont systemFontOfSize:18.0f];
    timer.timeLabel.textColor = [UIColor redColor];
    timer.timeFormat = @"ss";
    [self.view addSubview:timer];
    [timer setCountDownTime:15];
    [timer start];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        //oh my gosh, it's awesome!!
    }];
}

- (void)_pauseCapture
{
    [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)_resumeCapture
{
    [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)_endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)_resetCapture
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;

    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        vision.cameraDevice = PBJCameraDeviceBack;
    } else {
        vision.cameraDevice = PBJCameraDeviceFront;
    }
    
    vision.cameraMode = PBJCameraModeVideo;
    //vision.cameraMode = PBJCameraModePhoto; // PHOTO: uncomment to test photo capture
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat = PBJOutputFormatSquare;
    vision.videoRenderingEnabled = YES;
    vision.additionalCompressionProperties = @{AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30}; // AVVideoProfileLevelKey requires specific captureSessionPreset
    
    // specify a maximum duration with the following property
    // vision.maximumCaptureDuration = CMTimeMakeWithSeconds(5, 600); // ~ 5 seconds
}

#pragma mark - UIButton

- (void)_handleFlipButton:(UIButton *)button
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.cameraDevice = vision.cameraDevice == PBJCameraDeviceBack ? PBJCameraDeviceFront : PBJCameraDeviceBack;
}

#pragma mark - UIGestureRecognizer
- (void)_handleFocusTapGesterRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:_previewView];

    // auto focus is occuring, display focus view
    CGPoint point = tapPoint;
    
    CGRect focusFrame = _focusView.frame;
#if defined(__LP64__) && __LP64__
    focusFrame.origin.x = rint(point.x - (focusFrame.size.width * 0.5));
    focusFrame.origin.y = rint(point.y - (focusFrame.size.height * 0.5));
#else
    focusFrame.origin.x = rintf(point.x - (focusFrame.size.width * 0.5f));
    focusFrame.origin.y = rintf(point.y - (focusFrame.size.height * 0.5f));
#endif
    [_focusView setFrame:focusFrame];
    
    [_previewView addSubview:_focusView];
    [_focusView startAnimation];

    CGPoint adjustPoint = [PBJVisionUtilities convertToPointOfInterestFromViewCoordinates:tapPoint inFrame:_previewView.frame];
    [[PBJVision sharedInstance] focusExposeAndAdjustWhiteBalanceAtAdjustedPoint:adjustPoint];
}

#pragma mark - PBJVisionDelegate

// session

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
    if (![_previewView superview]) {
        [self.view addSubview:_previewView];
    }
    [self.view addSubview:_footerView];
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
    [_previewView removeFromSuperview];
    if(timer)
    {
        [timer reset];
    }
}

// preview

- (void)visionSessionDidStartPreview:(PBJVision *)vision
{
    NSLog(@"Camera preview did start");
    
}

- (void)visionSessionDidStopPreview:(PBJVision *)vision
{
    NSLog(@"Camera preview did stop");
}

// device

- (void)visionCameraDeviceWillChange:(PBJVision *)vision
{
    NSLog(@"Camera device will change");
}

- (void)visionCameraDeviceDidChange:(PBJVision *)vision
{
    NSLog(@"Camera device did change");
}

// mode

- (void)visionCameraModeWillChange:(PBJVision *)vision
{
    NSLog(@"Camera mode will change");
}

- (void)visionCameraModeDidChange:(PBJVision *)vision
{
    NSLog(@"Camera mode did change");
}

// format

- (void)visionOutputFormatWillChange:(PBJVision *)vision
{
    NSLog(@"Output format will change");
}

- (void)visionOutputFormatDidChange:(PBJVision *)vision
{
    NSLog(@"Output format did change");
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture
{
}

// focus / exposure

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
    if (_focusView && [_focusView superview]) {
        [_focusView stopAnimation];
    }
}

- (void)visionWillChangeExposure:(PBJVision *)vision
{
}

- (void)visionDidChangeExposure:(PBJVision *)vision
{
    if (_focusView && [_focusView superview]) {
        [_focusView stopAnimation];
    }
}

// flash

- (void)visionDidChangeFlashMode:(PBJVision *)vision
{
    NSLog(@"Flash mode did change");
}

// photo

- (void)visionWillCapturePhoto:(PBJVision *)vision
{
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    if (error) {
        // handle error properly
        return;
    }
    _currentPhoto = photoDict;
    
    // save to library
    NSData *photoData = _currentPhoto[PBJVisionPhotoJPEGKey];
    NSDictionary *metadata = _currentPhoto[PBJVisionPhotoMetadataKey];
   [_assetLibrary writeImageDataToSavedPhotosAlbum:photoData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error1) {
        if (error1 || !assetURL) {
            // handle error properly
            return;
        }
       
        NSString *albumName = @"PBJVision";
        __block BOOL albumFound = NO;
        [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                albumFound = YES;
                [_assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [group addAsset:asset];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved!" message: @"Saved to the camera roll."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
                    [alert show];
                } failureBlock:nil];
            }
            if (!group && !albumFound) {
                __weak ALAssetsLibrary *blockSafeLibrary = _assetLibrary;
                [_assetLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group1) {
                    [blockSafeLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group1 addAsset:asset];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Photo Saved!" message: @"Saved to the camera roll."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
                        [alert show];
                    } failureBlock:nil];
                } failureBlock:nil];
            }
        } failureBlock:nil];
    }];
    
    _currentPhoto = nil;
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    _recording = YES;
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    _recording = NO;

    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }

    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    
    UIStoryboard   *mainStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    PreviewViewController *pvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"PreviewViewController"];
    pvc.mediaStoragePath=videoPath;
    [self.navigationController pushViewController:pvc animated:YES];
    return;
    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video Saved!" message: @"Saved to the camera roll."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

// progress

- (void)vision:(PBJVision *)vision didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
//    NSLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
}

- (void)vision:(PBJVision *)vision didCaptureAudioSample:(CMSampleBufferRef)sampleBuffer
{
//    NSLog(@"captured video (%f) seconds", vision.capturedVideoSeconds);
}

@end
