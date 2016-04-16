//
//  TWShareUtility.h
//
//  Created by DesenGuo on 2016-03-09.
//

#import <Social/Social.h>
#ifndef TWShareUtility_h
#define TWShareUtility_h


#endif /* TWShareUtility_h */
@interface TWShareUtility : NSObject
+ (void)postToTwitterFromViewController:(UIViewController*)target
withInitialText:(NSString *)initialText
                           andURLString:(NSString *)urlString;
@end