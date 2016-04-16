//
//  FacebookHelper.h
//
//  Created by DesenGuo on 2016-02-22.
//
#import "FacebookUtility.h"
#import "Alert.h"
#import "AccountInfoCache.h"
#import "Contact.h"

#ifndef FacebookHelper_h
#define FacebookHelper_h


#endif /* FacebookHelper_h */
@interface FacebookHelper : NSObject
+ (instancetype)sharedInstance;
-(BOOL)isFacebookLoggedIn;
-(void)logoutWithFunctionBlock:(FunctionBlock)block;
-(void)loginFromViewController:(UIViewController*)viewController
             withFunctionBlock:(FunctionBlock)block;
-(void)updateFBFriendsFromViewController:(UIViewController*)viewController
                       withFunctionBlock:(FunctionBlock)block;
-(NSMutableArray *)getFacebookContacts;
@end