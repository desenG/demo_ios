//
//  AssetsEditor.m
//
//  Created by DesenGuo on 2016-01-07.
//

#import <Foundation/Foundation.h>

#import "AssetsEditor.h"

@implementation AssetsEditor
{
}

#define degreesToRadians(x) (M_PI * x / 180.0)
//this is asyc task with callback
- (void)physicallyRotateVideoWithInputAssetWithCompletionHandler:(AVAsset*) videoAsset
                                                       outputURL:(NSURL*)outputURL
                                                         handler:(void(^)(bool))handler
{
    @try {
        NSError *error = nil;        
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degreesToRadians(270));
        CGAffineTransform transformToApply = CGAffineTransformTranslate(rotationTransform,-640,0);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
        [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAsset.duration);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
        videoComposition.renderScale = 1.0;
        videoComposition.renderSize = CGSizeMake(480, 640); //select you video size
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        
        exportSession.outputURL=outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusCompleted: {
                    
                    NSLog(@"Rotated Completed");
                    if(handler!=nil)
                    {
                        handler(true);
                    }
                    break;
                }
                default: {
                    break;
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        handler(false);
    }
    @finally {
        
    }
    
}
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
- (BOOL)fixedVideoSizeWithInputAsset:( NSURL*) inputVideoURL
                        outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputVideoURL options:nil];
        //create an avassetrack with our asset
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        //create a video composition and preset some settings
        AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.frameDuration = CMTimeMake(1, 30);
        //here we are setting its render size to its height x height (Square)
        videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height);
        
        //create a video instruction
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
        
        AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        CGAffineTransform t3 = CGAffineTransformTranslate(videoTrack.preferredTransform, (videoTrack.naturalSize.height - videoTrack.naturalSize.width) /2, 0);

        CGAffineTransform finalTransform = t3;
        [transformer setTransform:finalTransform atTime:kCMTimeZero];
        
        //add the transformer layer instructions, then add to video composition
        instruction.layerInstructions = [NSArray arrayWithObject:transformer];
        videoComposition.instructions = [NSArray arrayWithObject: instruction];
        //Create an Export Path to store the cropped video
        NSURL *exportUrl = outputURL;
        //Export
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
        exportSession.videoComposition = videoComposition;
        exportSession.outputURL = exportUrl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    
                    NSLog(@"Resize Completed");
                    success_  = YES;
                    
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
                case AVAssetExportSessionStatusExporting:
                {
                    break;
                }
                case AVAssetExportSessionStatusUnknown:
                {
                    break;
                }
                case AVAssetExportSessionStatusWaiting:
                {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }

}

- (BOOL)resizeVideoWithInputAsset:( NSURL*) inputVideoURL
                        outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        NSError *error = nil;
        AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:inputVideoURL  options:nil];

        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        CGFloat height=[videoTrack naturalSize].height;
        CGFloat width=[videoTrack naturalSize].width;

        CGFloat AssetScaleToFitRatio = 480.0/width;
        //resize
        CGAffineTransform transformToApply = CGAffineTransformMakeScale(AssetScaleToFitRatio,AssetScaleToFitRatio);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
//        [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
        [layerInstruction setTransform:CGAffineTransformConcat(videoTrack.preferredTransform, transformToApply) atTime:videoAsset.duration];
        [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAsset.duration);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
        videoComposition.renderScale = 1.0;
        videoComposition.renderSize = CGSizeMake(480, 640); //select you video size
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        
        exportSession.outputURL=outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    if(error == nil)
                    {
                        NSLog(@"Resize Completed");
                        success_  = YES;
                    }
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
                case AVAssetExportSessionStatusExporting:
                {
                    break;
                }
                case AVAssetExportSessionStatusUnknown:
                {
                    break;
                }
                case AVAssetExportSessionStatusWaiting:
                {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

//this is syc task, for uncerntain reason the output video is always 320x480
- (BOOL)physicallyRotateVideoWithInputAsset:(AVAsset*) videoAsset
                                                       outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        NSError *error = nil;
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        CGFloat height=[videoTrack naturalSize].height;
        CGFloat width=[videoTrack naturalSize].width;
        //the video is not portrait
        CGFloat AssetScaleToFitRatio = 640.0/width;
        //resize
        CGAffineTransform AssetScaleFactor = CGAffineTransformMakeScale(AssetScaleToFitRatio,AssetScaleToFitRatio);
        //rotate
        CGAffineTransform rotationTransform = CGAffineTransformRotate(AssetScaleFactor, degreesToRadians(270));
        //offset
        CGAffineTransform transformToApply = CGAffineTransformTranslate(rotationTransform,-640,0);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
        [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAsset.duration);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
        videoComposition.renderScale = 1.0;
        videoComposition.renderSize = CGSizeMake(480, 640); //select you video size
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        
        exportSession.outputURL=outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusCompleted: {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        success_  = YES;
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);

        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

-(BOOL)watermarkFile:( NSURL*) inputVideoURL
        watermarkImg:(UIImage *) inputwatermarkImage
           withWidth:(int) width
          andHeight:(int) height
           isLeftTop:(BOOL)isLeftTop
           outputURL:(NSURL*)outputURL
{
    UIImage * watermarkImage=inputwatermarkImage;
    if(width!=0 && height!=0)
    {
        watermarkImage=[self resizeImageThumb:inputwatermarkImage withWidth:width withHeight:height];
    }
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        CALayer *aLayer = [CALayer layer];
        aLayer.frame = CGRectMake(0, 640-watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height);
        aLayer.bounds = CGRectMake(0, 640-watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height);
        
        if(!isLeftTop)
        {
            aLayer.frame = CGRectMake(480-watermarkImage.size.width, 0, watermarkImage.size.width, watermarkImage.size.height);
            aLayer.bounds = CGRectMake(480-watermarkImage.size.width, 0, watermarkImage.size.width, watermarkImage.size.height);
            
        }
        aLayer.contents = (id) watermarkImage.CGImage;
        aLayer.opacity = 0.5;
        aLayer.backgroundColor = [UIColor clearColor].CGColor;
        AVURLAsset* asset = [[AVURLAsset alloc]initWithURL:inputVideoURL  options:nil];
        AVMutableComposition *composition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack *trackA = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] == 0 || [[asset tracksWithMediaType:AVMediaTypeAudio] count] == 0) {
            return false;
        }
        AVAssetTrack *sourceVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        
        CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
        CGSize size = CGSizeMake(480, 640);
        CGAffineTransform transform = sourceVideoTrack.preferredTransform;
        
        AVMutableVideoComposition *animComp = [AVMutableVideoComposition videoComposition];
        animComp.renderScale = 1.0;
        animComp.frameDuration = CMTimeMake(1,30);
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        
        parentLayer.frame = CGRectMake(0, 0, size.width,size.height );
        videoLayer.frame = CGRectMake(0, 0, size.width,size.height);
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:aLayer];
        animComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:trackA];
        
        CGFloat SecondAssetScaleToFitRatio = 640.0/fabs(temp.height);
        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
        [layerInstruction setTransform:CGAffineTransformConcat(sourceVideoTrack.preferredTransform, SecondAssetScaleFactor) atTime:CMTimeMakeWithSeconds(0, 30)];
        NSError *error;
        [trackA insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:sourceVideoTrack
                         atTime:[composition duration] error:&error];
        
        
        AVMutableCompositionTrack *compositionCommentaryTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                         preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *sourceAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        CMTimeRange commentaryTimeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(commentaryTimeRange), >, [composition duration]))
        {
            commentaryTimeRange.duration = CMTimeSubtract([composition duration], commentaryTimeRange.start);
        }
        // Add the audio track.
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:sourceAudioTrack atTime:commentaryTimeRange.start error:nil];
        //[layerInstruction setTrackID:2];
        [layerInstruction setOpacity:1.0 atTime:kCMTimeZero];
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction] ;
        animComp.instructions = [NSArray arrayWithObject:instruction];
        animComp.renderSize = size;
        
        AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];//AVAssetExportPresetPassthrough
        assetExport.videoComposition = animComp;
        assetExport.outputFileType = AVFileTypeMPEG4;
        assetExport.outputURL = outputURL;
        assetExport.shouldOptimizeForNetworkUse = YES;
        [assetExport exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([assetExport status]) {
                    
                case AVAssetExportSessionStatusCompleted: {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        success_  = YES;
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

-(BOOL)watermarkFile:( NSURL*) inputVideoURL
        watermarkImg:(UIImage *) watermarkImage
           outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        CALayer *watermarkLayer = [CALayer layer];
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        watermarkLayer.frame = CGRectMake(480-watermarkImage.size.width-10, 0, watermarkImage.size.width, watermarkImage.size.height);
        watermarkLayer.bounds = CGRectMake(480-watermarkImage.size.width-10, 0, watermarkImage.size.width, watermarkImage.size.height);
        watermarkLayer.contents = (id) watermarkImage.CGImage;
        watermarkLayer.opacity = 0.5;
        watermarkLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack =
        [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                 preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack =
        [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                 preferredTrackID:kCMPersistentTrackID_Invalid];
        AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:inputVideoURL  options:nil];
        

        
        if ([[videoAsset tracksWithMediaType:AVMediaTypeVideo] count] == 0 || [[videoAsset tracksWithMediaType:AVMediaTypeAudio] count] == 0) {
            return false;
        }
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

        
        CGSize temp = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
        CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
        CGAffineTransform transform = videoTrack.preferredTransform;

        parentLayer.frame = CGRectMake(0, 0, size.width,size.height );
        videoLayer.frame = CGRectMake(0, 0, size.width,size.height);
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:watermarkLayer];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.renderScale = 1.0;
        videoComposition.frameDuration = CMTimeMake(1,30);
        videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        NSError *error;
        
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:videoTrack
                         atTime:[composition duration] error:&error];
        
        

        CMTimeRange commentaryTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(commentaryTimeRange), >, [composition duration]))
        {
            commentaryTimeRange.duration = CMTimeSubtract([composition duration], commentaryTimeRange.start);
        }
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:commentaryTimeRange.start error:nil];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transform atTime:CMTimeMakeWithSeconds(0, 30)];
        [layerInstruction setOpacity:1.0 atTime:kCMTimeZero];
        
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction] ;
        videoComposition.instructions = [NSArray arrayWithObject:instruction];
        videoComposition.renderSize = size;
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
        exportSession.videoComposition = videoComposition;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.outputURL = outputURL;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusCompleted: {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        success_  = YES;
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

- (BOOL)rotateAndWatermarkVideoWithInputAsset:(AVAsset*) videoAsset
                                isQuestionVideo:(BOOL) isQuestion
                                    outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        NSError *error = nil;
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        CGFloat width=[videoTrack naturalSize].width;
        //the video is not portrait
        CGFloat AssetScaleToFitRatio = 640.0/width;
        //resize
        CGAffineTransform AssetScaleFactor = CGAffineTransformMakeScale(AssetScaleToFitRatio,AssetScaleToFitRatio);
        //rotate
        UIImageOrientation assetOrientation_  = UIImageOrientationUp;
        CGAffineTransform transform = videoTrack.preferredTransform;
        if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0)  {assetOrientation_= UIImageOrientationRight; }
        if(transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0)  {assetOrientation_ =  UIImageOrientationLeft;}
        CGAffineTransform rotationTransform = CGAffineTransformRotate(AssetScaleFactor, degreesToRadians(270));
        //offset
        CGAffineTransform transformToApply = CGAffineTransformTranslate(rotationTransform,-640,0);
        
        if(assetOrientation_==UIImageOrientationRight)
        {
            rotationTransform = CGAffineTransformRotate(AssetScaleFactor, degreesToRadians(90));
            transformToApply = CGAffineTransformTranslate(rotationTransform,0,-480);
        }

        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
        [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAsset.duration);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
        videoComposition.renderScale = 1.0;
        videoComposition.renderSize = CGSizeMake(480, 640); //select you video size
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *rotateVideoPath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"rotateVideo-%d.mp4",arc4random() % 1000]];
        
        NSURL *rotateVideoUrl = [NSURL fileURLWithPath:rotateVideoPath];
        exportSession.outputURL=rotateVideoUrl;
        exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        NSURL *resizedVideoUrl = [NSURL fileURLWithPath:rotateVideoPath];
                        if([self resizeVideoWithInputAsset:rotateVideoUrl outputURL:resizedVideoUrl])
                        {
                            success_  = [self watermarkFile:resizedVideoUrl isQuestionVideo:isQuestion outputURL:outputURL];
                        }
                        if([[NSFileManager defaultManager] fileExistsAtPath:rotateVideoPath])
                        {
                            //remove rotate video temp file
                            [[NSFileManager defaultManager] removeItemAtPath:rotateVideoPath error:nil];
                        }
                    }
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
                case AVAssetExportSessionStatusExporting:
                {
                    break;
                }
                case AVAssetExportSessionStatusUnknown:
                {
                    break;
                }
                case AVAssetExportSessionStatusWaiting:
                {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

-(BOOL)watermarkFile:( NSURL*) inputVideoURL
        isQuestionVideo:(BOOL) isQuestion
           outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        CALayer *aLayer = [CALayer layer];
        UIImage * watermarkImage = [UIImage imageNamed:@"img_watermark_dive_top.png"];
        aLayer.frame = CGRectMake(0, 640-watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height);
        aLayer.bounds = CGRectMake(0, 640-watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height);

        if(!isQuestion)
        {
            watermarkImage = [UIImage imageNamed:@"img_watermark_dive_bottom.png"];
            aLayer.frame = CGRectMake(480-watermarkImage.size.width, 0, watermarkImage.size.width, watermarkImage.size.height);
            aLayer.bounds = CGRectMake(480-watermarkImage.size.width, 0, watermarkImage.size.width, watermarkImage.size.height);

        }
        aLayer.contents = (id) watermarkImage.CGImage;
        aLayer.opacity = 0.5;
        aLayer.backgroundColor = [UIColor clearColor].CGColor;
        AVURLAsset* asset = [[AVURLAsset alloc]initWithURL:inputVideoURL  options:nil];
        AVMutableComposition *composition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack *trackA = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] == 0 || [[asset tracksWithMediaType:AVMediaTypeAudio] count] == 0) {
            return false;
        }
        AVAssetTrack *sourceVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        
        CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
        CGSize size = CGSizeMake(480, 640);
        CGAffineTransform transform = sourceVideoTrack.preferredTransform;
        
        AVMutableVideoComposition *animComp = [AVMutableVideoComposition videoComposition];
        animComp.renderScale = 1.0;
        animComp.frameDuration = CMTimeMake(1,30);
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        
        parentLayer.frame = CGRectMake(0, 0, size.width,size.height );
        videoLayer.frame = CGRectMake(0, 0, size.width,size.height);
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:aLayer];
        animComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:trackA];
        
        CGFloat SecondAssetScaleToFitRatio = 640.0/fabs(temp.height);
        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
        [layerInstruction setTransform:CGAffineTransformConcat(sourceVideoTrack.preferredTransform, SecondAssetScaleFactor) atTime:CMTimeMakeWithSeconds(0, 30)];
        NSError *error;
        [trackA insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:sourceVideoTrack
                         atTime:[composition duration] error:&error];
        
        
        AVMutableCompositionTrack *compositionCommentaryTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                 preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *sourceAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        CMTimeRange commentaryTimeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(commentaryTimeRange), >, [composition duration]))
        {
            commentaryTimeRange.duration = CMTimeSubtract([composition duration], commentaryTimeRange.start);
        }
        // Add the audio track.
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:sourceAudioTrack atTime:commentaryTimeRange.start error:nil];
        //[layerInstruction setTrackID:2];
        [layerInstruction setOpacity:1.0 atTime:kCMTimeZero];
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction] ;
        animComp.instructions = [NSArray arrayWithObject:instruction];
        animComp.renderSize = size;
        
        AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];//AVAssetExportPresetPassthrough
        assetExport.videoComposition = animComp;
        assetExport.outputFileType = AVFileTypeMPEG4;
        assetExport.outputURL = outputURL;
        assetExport.shouldOptimizeForNetworkUse = YES;
        [assetExport exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([assetExport status]) {
                    
                case AVAssetExportSessionStatusCompleted: {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        success_  = YES;
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}
//this is syc task with callback, for uncerntain reason the output video is always 320x480
- (BOOL)rotateAndWatermarkVideoWithInputAsset:(AVAsset*) videoAsset
                                                      watermarkImg:(UIImage *) watermarkImage
                                                       outputURL:(NSURL*)outputURL
{
    @try {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL  success_  = NO;
        NSError *error = nil;
        AVMutableComposition *composition = [AVMutableComposition composition];
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        
        CGFloat height=[videoTrack naturalSize].height;
        CGFloat width=[videoTrack naturalSize].width;
        //the video is not portrait
        CGFloat AssetScaleToFitRatio = 640.0/width;
        //resize
        CGAffineTransform AssetScaleFactor = CGAffineTransformMakeScale(AssetScaleToFitRatio,AssetScaleToFitRatio);
        //rotate
        CGAffineTransform rotationTransform = CGAffineTransformRotate(AssetScaleFactor, degreesToRadians(270));
        //offset
        CGAffineTransform transformToApply = CGAffineTransformTranslate(rotationTransform,-640,0);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
        [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAsset.duration);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
        videoComposition.renderScale = 1.0;
        videoComposition.renderSize = CGSizeMake(480, 640); //select you video size
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *rotateVideoPath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"rotateVideo-%d.mp4",arc4random() % 1000]];
        
        NSURL *rotateVideoUrl = [NSURL fileURLWithPath:rotateVideoPath];
        exportSession.outputURL=rotateVideoUrl;
        exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    if(error == nil)
                    {
                        NSLog(@"Rotated Completed");
                        success_  = [self watermarkFile:rotateVideoUrl watermarkImg:watermarkImage outputURL:outputURL];
                    }
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
                case AVAssetExportSessionStatusExporting:
                {
                    break;
                }
                case AVAssetExportSessionStatusUnknown:
                {
                    break;
                }
                case AVAssetExportSessionStatusWaiting:
                {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
            
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return success_;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
        return false;
    }
}

-(BOOL) isAssetPortrait:(AVAsset*) videoAsset
{
    AVAssetTrack *AssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGFloat height=[AssetTrack naturalSize].height;
    CGFloat width=[AssetTrack naturalSize].width;
    return (width<height);
}

//This solution will generate temp file
-(NSString *) mergeFirstAssetAndSave1:(AVAsset*) _firstAsset withSecondAsset:(AVAsset*) _secondAsset
{
    @try
    {
        NSString *myPathDocs = @"";
        NSString *newPath = @"";
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        if(_firstAsset !=nil && _secondAsset!=nil){
            AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
            
            //VIDEO TRACK
            NSLog(@"VIDEO COUNT : %lu",(unsigned long)[[_firstAsset tracksWithMediaType:AVMediaTypeVideo] count]);
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            if([[_firstAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0)
            {
                [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _firstAsset.duration) ofTrack:[[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            }
            
            if([[_firstAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0)
            {
                AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _firstAsset.duration) ofTrack:[[_firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            }
            
            NSLog(@"VIDEO COUNT : %lu",(unsigned long)[[_secondAsset tracksWithMediaType:AVMediaTypeVideo] count]);
            AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            if([[_secondAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0)
            {
                [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _secondAsset.duration) ofTrack:[[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:_firstAsset.duration error:nil];
            }
            
            if([[_secondAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0)
            {
                AVMutableCompositionTrack *secondAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                [secondAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _secondAsset.duration) ofTrack:[[_secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:_firstAsset.duration error:nil];
            }
            
            
            AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(_firstAsset.duration, _secondAsset.duration));
            
            //FIXING ORIENTATION//
            AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            AVAssetTrack *FirstAssetTrack = [[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            NSLog(@"%@",[[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]);
            CGSize temp = CGSizeApplyAffineTransform(FirstAssetTrack.naturalSize, FirstAssetTrack.preferredTransform);
            CGSize size = CGSizeMake(fabsf(temp.width), fabsf(temp.height));
            
            CGFloat FirstAssetScaleToFitRatio = 1;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
            
            
            [FirstlayerInstruction setOpacity:0.0 atTime:_firstAsset.duration];
            
            AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
            NSLog(@"%@",[[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]);
            AVAssetTrack *SecondAssetTrack = [[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            
            temp = CGSizeApplyAffineTransform(SecondAssetTrack.naturalSize, SecondAssetTrack.preferredTransform);
            size = CGSizeMake(fabsf(temp.width), fabsf(temp.height));
            CGFloat SecondAssetScaleToFitRatio = 1;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:_firstAsset.duration];

            
            MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];
            
            AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
            MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
            MainCompositionInst.frameDuration = CMTimeMake(1, 30);
            
            MainCompositionInst.renderSize = CGSizeMake(480.0, 640.0);;

            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo.mp4"]];
            newPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo2.mp4"]];
            
            NSURL *url = [NSURL fileURLWithPath:myPathDocs];
            
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
            exporter.outputURL=url;
            exporter.outputFileType = AVFileTypeMPEG4;
            exporter.videoComposition = MainCompositionInst;
            exporter.shouldOptimizeForNetworkUse = YES;
            
            [exporter exportAsynchronouslyWithCompletionHandler:^
             {
                 NSLog(@"FINISHED");
                 NSError *error;
                 if ([[NSFileManager defaultManager] fileExistsAtPath:newPath])
                 {
                     [[NSFileManager defaultManager] removeItemAtPath:newPath error:&error];
                 }
                 if (![[NSFileManager defaultManager] moveItemAtPath:myPathDocs toPath:newPath error:&error]) {
                     NSLog(@"RENAME FAILED with Error : %@",[error localizedDescription]);
                 }
                 else
                 {
                     NSLog(@"MOVE SUCCESS");
                 }
                 NSLog(@"SAVED");
                 dispatch_semaphore_signal(sema);
             }];
        }
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return newPath;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }

}
//This solution wont generate temp file, implement in future.
-(void) mergeFirstAssetAndSave2:(AVAsset*) _firstAsset withSecondAsset:(AVAsset*) _secondAsset
{
}

-(BOOL)saveAVAsset:(AVAsset*)asset
            toPathURL:( NSURL*) outputPathURL
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block BOOL success=NO;
    @try {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        
        exportSession.outputURL = outputPathURL;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    success=YES;
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
                case AVAssetExportSessionStatusExporting:
                {
                    break;
                }
                case AVAssetExportSessionStatusUnknown:
                {
                    break;
                }
                case AVAssetExportSessionStatusWaiting:
                {
                    break;
                }
            }
            dispatch_semaphore_signal(sema);
        }];
    }
    @catch (NSException *exception) {
        dispatch_semaphore_signal(sema);
    }
    @finally {
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return success;
}

-(void)watermarkIMGWithVideoPath:(NSString *)videoPath
{
    UIImage *watermarkImage = [UIImage imageNamed:@"img_watermark_dive_top.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:videoPath];
    
    //Add watermark to Image
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    [watermarkImage drawInRect:CGRectMake(0,0,watermarkImage.size.width, watermarkImage.size.height)];
    
    UIImage *newwatermarkimage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imgData = UIImagePNGRepresentation(newwatermarkimage);
    [imgData writeToFile:videoPath atomically:YES];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

// Returns largest possible centered cropped image.
- (UIImage *)centerCropImage:(UIImage *)image
{
    // Use smallest side length as crop square length
    CGFloat squareLength = MIN(image.size.width, image.size.height);
    // Center the crop area
    CGRect clippedRect = CGRectMake((image.size.width - squareLength) / 2, (image.size.height - squareLength) / 2, squareLength, squareLength);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

-(UIImage *)resizeImageThumb:(UIImage *)image withWidth:(int) width withHeight:(int) height
{
    UIImage * img_cropped=[self centerCropImage:image];
    CGImageRef imageRef = [img_cropped CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    CGContextRef bitmap;
    
    if (img_cropped.imageOrientation == UIImageOrientationUp | img_cropped.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo,(CGBitmapInfo) alphaInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo,(CGBitmapInfo) alphaInfo);
        
    }
    
    if (img_cropped.imageOrientation == UIImageOrientationLeft) {
        NSLog(@"image orientation left");
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -height);
        
    } else if (img_cropped.imageOrientation == UIImageOrientationRight) {
        NSLog(@"image orientation right");
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -width, 0);
        
    } else if (img_cropped.imageOrientation == UIImageOrientationUp) {
        NSLog(@"image orientation up");
        
    } else if (img_cropped.imageOrientation == UIImageOrientationDown) {
        NSLog(@"image orientation down");
        CGContextTranslateCTM (bitmap, width,height);
        CGContextRotateCTM (bitmap, radians(-180.));
        
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (void)convertMOVVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                         andCompletedHandler:(void (^)(void))handler
{
    @try {
        //setup video writer
        AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:inputURL options:nil];
        NSLog(@"COUNT : %lu",(unsigned long)[[videoAsset tracksWithMediaType:AVMediaTypeVideo] count]);
        AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        CGSize videoSize = videoTrack.naturalSize;
        
        NSDictionary *videoWriterCompressionSettings =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1250000], AVVideoAverageBitRateKey, nil];
        
        NSDictionary *videoWriterSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey, videoWriterCompressionSettings, AVVideoCompressionPropertiesKey, [NSNumber numberWithFloat:videoSize.width], AVVideoWidthKey, [NSNumber numberWithFloat:videoSize.height], AVVideoHeightKey, nil];
        
        AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                                assetWriterInputWithMediaType:AVMediaTypeVideo
                                                outputSettings:videoWriterSettings];
        
        videoWriterInput.expectsMediaDataInRealTime = YES;
        
        videoWriterInput.transform = videoTrack.preferredTransform;
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:nil];
        
        [videoWriter addInput:videoWriterInput];
        
        //setup video reader
        NSDictionary *videoReaderSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        
        AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoReaderSettings];
        
        AVAssetReader *videoReader = [[AVAssetReader alloc] initWithAsset:videoAsset error:nil];
        
        [videoReader addOutput:videoReaderOutput];
        
        //setup audio writer
        AVAssetWriterInput* audioWriterInput = [AVAssetWriterInput
                                                assetWriterInputWithMediaType:AVMediaTypeAudio
                                                outputSettings:nil];
        
        audioWriterInput.expectsMediaDataInRealTime = NO;
        
        [videoWriter addInput:audioWriterInput];
        
        //setup audio reader
        AVAssetTrack* audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        
        AVAssetReaderOutput *audioReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
        
        AVAssetReader *audioReader = [AVAssetReader assetReaderWithAsset:videoAsset error:nil];
        
        [audioReader addOutput:audioReaderOutput];
        
        [videoWriter startWriting];
        
        //start writing from video reader
        [videoReader startReading];
        
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue1", NULL);
        
        [videoWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:
         ^{
             
             while ([videoWriterInput isReadyForMoreMediaData]) {
                 
                 CMSampleBufferRef sampleBuffer;
                 
                 if ([videoReader status] == AVAssetReaderStatusReading &&
                     (sampleBuffer = [videoReaderOutput copyNextSampleBuffer])) {
                     
                     [videoWriterInput appendSampleBuffer:sampleBuffer];
                     CFRelease(sampleBuffer);
                 }
                 
                 
                 else {
                     
                     [videoWriterInput markAsFinished];
                     
                     if ([videoReader status] == AVAssetReaderStatusCompleted) {
                         
                         //[self sendMovieFileAtURL:outputURL];
                         
                         
                         //start writing from audio reader
                         [audioReader startReading];
                         
                         [videoWriter startSessionAtSourceTime:kCMTimeZero];
                         
                         dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue2", NULL);
                         
                         [audioWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:^{
                             
                             while (audioWriterInput.readyForMoreMediaData) {
                                 
                                 CMSampleBufferRef sampleBuffer;
                                 
                                 if ([audioReader status] == AVAssetReaderStatusReading &&
                                     (sampleBuffer = [audioReaderOutput copyNextSampleBuffer])) {
                                     
                                     [audioWriterInput appendSampleBuffer:sampleBuffer];
                                     CFRelease(sampleBuffer);
                                 }
                                 
                                 else {
                                     
                                     [audioWriterInput markAsFinished];
                                     
                                     if ([audioReader status] == AVAssetReaderStatusCompleted) {
                                         
                                         [videoWriter finishWritingWithCompletionHandler:handler];
                                         
                                     }
                                 }
                             }
                             
                         }
                          ];
                         
                         
                     }
                 }
             }
         }
         ];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Catched");
    }
    @finally {
        
    }
    
}

-(void) sendGIFFileToAlbumAtURL:(NSURL*)gifURL
{
    NSData *gifData = [NSData dataWithContentsOfURL:gifURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"Success at %@", [assetURL path] );
    }];
}

-(void) sendMovieFileToAlbumAtURL:(NSURL*)outputURL
{
    NSLog(@"VIDEO CONVERTED");
    //save the movie to camera roll
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){
                                        if (error) {
                                            NSLog(@"error Video Saving Failed ::%@",[error description]);
                                        }else{
                                            
                                        }
                                        
                                    }];
    }
}
@end