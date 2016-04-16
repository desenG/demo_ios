//
//  AssetsEditor.h
//
//  Created by DesenGuo on 2016-01-07.
//

#ifndef AssetsEditor_h
#define AssetsEditor_h


#endif /* AssetsEditor_h */
#import <AVFoundation/AVFoundation.h>
@interface AssetsEditor : NSObject
- (BOOL)physicallyRotateVideoWithInputAsset:(AVAsset*) videoAsset
                                                       outputURL:(NSURL*)outputURL;
- (BOOL)rotateAndWatermarkVideoWithInputAsset:(AVAsset*) videoAsset
                              isQuestionVideo:(BOOL) isQuestion
                                    outputURL:(NSURL*)outputURL;
-(BOOL) isAssetPortrait:(AVAsset*) videoAsset;
-(NSString *) mergeFirstAssetAndSave1:(AVAsset*) _firstAsset withSecondAsset:(AVAsset*) _secondAsset;
- (BOOL)fixedVideoSizeWithInputAsset:( NSURL*) inputVideoURL
                           outputURL:(NSURL*)outputURL;
-(void)watermarkIMGWithVideoPath:(NSString *)videoPath;
-(UIImage *)resizeImageThumb:(UIImage *)image withWidth:(int) width withHeight:(int) height;
-(BOOL)saveAVAsset:(AVAsset*)asset
         toPathURL:( NSURL*) outputPathURL;
- (void)convertMOVVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
outputURL:(NSURL*)outputURL
                         andCompletedHandler:(void (^)(void))handler;
-(void) sendMovieFileToAlbumAtURL:(NSURL*)outputURL;
-(BOOL)watermarkFile:( NSURL*) inputVideoURL
watermarkImg:(UIImage *) watermarkImage
           outputURL:(NSURL*)outputURL;
-(BOOL)watermarkFile:( NSURL*) inputVideoURL
watermarkImg:(UIImage *) inputwatermarkImage
withWidth:(int) width
andHeight:(int) height
isLeftTop:(BOOL)isLeftTop
           outputURL:(NSURL*)outputURL;
-(void) sendGIFFileToAlbumAtURL:(NSURL*)gifURL;
@end