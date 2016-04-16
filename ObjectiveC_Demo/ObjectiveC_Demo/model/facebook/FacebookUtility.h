//
//  FacebookUtility.h
//
//  Created by DesenGuo on 2016-02-04.
//
#import "FBCache.h"
#import "TypeDefinition.h"
#import "FBContact.h"
#import "SBJsonParser.h"

#ifndef FacebookUtility_h
#define FacebookUtility_h


#endif /* FacebookUtility_h */
@interface FacebookUtility:NSObject
+ (instancetype)sharedInstance;
-(BOOL)isLoggedIn;
-(void)loginFromViewController:(UIViewController*)viewController
             withFunctionBlock:(FunctionBlock)block;
-(void)logoutWithFunctionBlock:(FunctionBlock)block;
-(void)updateFBFriensWithToken:(FBSDKAccessToken*) token
                 FunctionBlock:(FunctionBlock)block;
@end