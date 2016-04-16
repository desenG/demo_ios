//
//  MediaPicker.h
//  FacebookHelper
//
//  Created by DesenGuo on 2016-03-08.
//  Copyright © 2016 divecommunications. All rights reserved.
//

#ifndef MediaPicker_h
#define MediaPicker_h


#endif /* MediaPicker_h */
@interface MediaPicker : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate>
{
    
}
@property(nonatomic,retain)AVAsset* pickedAsset;
@property(nonatomic,retain)NSURL * pickedAssetURL;
@property(nonatomic,retain)UIImage *  pickedImage;
@property(nonatomic,retain)UIViewController* m_controller;
@property (nonatomic,copy)GetDataCompletitionBlock completitionBlock;
-(void)loadAssetFromViewController:(UIViewController*) p_viewcontroller
WithAssetType: (NSString*)assetType// movie-kUTTypeMovie image-kUTTypeImage
andUIImagePickerControllerSourceType: (NSInteger)resourceType// UIImagePickerControllerSourceTypeCamera/UIImagePickerControllerSourceTypeSavedPhotosAlbum
       andGetDataCompletitionBlock:(GetDataCompletitionBlock) loadDataCompletitionBlock;
@end