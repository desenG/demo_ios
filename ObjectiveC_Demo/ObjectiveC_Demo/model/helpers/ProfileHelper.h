//
//  ProfileHelper.h
//

#ifndef ProfileHelper_h
#define ProfileHelper_h


#endif /* ProfileHelper_h */
#import <UIKit/UIKit.h>

@interface ProfileHelper: NSObject
{

}
- (BOOL)saveTempProfileImage:(NSString*)userid;
- (BOOL)saveProfileImageAsTempFile:(NSData *)pngImageData;
- (UIImage*)getSavedProfileImage;
- (NSURL*)getProfileImageURL;
@end