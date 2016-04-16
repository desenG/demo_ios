//
//  MediaPicker.m
//  FacebookHelper
//
//  Created by DesenGuo on 2016-03-08.
//  Copyright © 2016 divecommunications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaPicker.h"
@implementation MediaPicker

@synthesize pickedAsset,m_controller,pickedAssetURL,pickedImage;

-(void)loadAssetFromViewController:(UIViewController*) p_viewcontroller
WithAssetType: (NSString*)assetType// movie-kUTTypeMovie image-kUTTypeImage
andUIImagePickerControllerSourceType: (NSInteger)resourceType
  andGetDataCompletitionBlock:(GetDataCompletitionBlock) loadDataCompletitionBlock
{
    m_controller=p_viewcontroller;
    _completitionBlock=loadDataCompletitionBlock;
    [self startMediaBrowserFromViewController:m_controller usingDelegate:self assetType:assetType UIImagePickerControllerSourceType:resourceType];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate
                                   assetType: (NSString*)assetType// movie-kUTTypeMovie image-kUTTypeImage
           UIImagePickerControllerSourceType: (NSInteger)resourceType
{
    
//    if([assetType isEqualToString:(NSString*)kUTTypeImage])
//    {
//        return [self startImageBrowserFromViewController:controller usingDelegate:delegate assetType:(NSString*)kUTTypeImage UIImagePickerControllerSourceType:resourceType];
//    }

    return [self startImageBrowserFromViewController:controller usingDelegate:delegate assetType:assetType UIImagePickerControllerSourceType:resourceType];;
}

- (BOOL) startImageBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate
                                   assetType: (NSString*)assetType// movie-kUTTypeMovie image-kUTTypeImage
           UIImagePickerControllerSourceType: (NSInteger)resourceType
{
    
    if ((delegate == nil)
        || (controller == nil))
        return NO;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];

    if(resourceType==UIImagePickerControllerSourceTypeSavedPhotosAlbum && ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO))
        return NO;
    if(resourceType==UIImagePickerControllerSourceTypeCamera && ([UIImagePickerController isSourceTypeAvailable:
                                                                            UIImagePickerControllerSourceTypeCamera] == NO))
    {
        return NO;
    }
    
    mediaUI.sourceType = resourceType;
    
    if(resourceType==UIImagePickerControllerSourceTypeCamera)
    {
        mediaUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: assetType, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}



// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [m_controller dismissViewControllerAnimated:NO completion:nil];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        NSLog(@"Captured is movie");
        pickedAssetURL=[info objectForKey:UIImagePickerControllerMediaURL];
        pickedAsset = [AVAsset assetWithURL:pickedAssetURL];
        if(_completitionBlock)
        {
            _completitionBlock(pickedAssetURL,nil);
        }
    }
    else if(CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo)
    {
        NSLog(@"Captured is image");
        pickedAssetURL=[info objectForKey:UIImagePickerControllerReferenceURL];
        pickedAsset = [AVAsset assetWithURL:pickedAssetURL];
        pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if(_completitionBlock)
        {
            _completitionBlock(pickedImage,nil);
        }
    }
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [m_controller dismissViewControllerAnimated:NO completion:nil];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [m_controller dismissViewControllerAnimated:NO completion:nil];
}

@end