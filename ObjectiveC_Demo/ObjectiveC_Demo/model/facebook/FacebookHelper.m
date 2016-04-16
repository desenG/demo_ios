//
//  FacebookHelper.m
//
//  Created by DesenGuo on 2016-02-22.
//

#import <Foundation/Foundation.h>
#import "FacebookHelper.h"
static FacebookHelper *_sharedInstance;

@implementation FacebookHelper

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FacebookHelper new];
    });
    return _sharedInstance;
}

-(BOOL)isFacebookLoggedIn
{
   return [[FacebookUtility sharedInstance] isLoggedIn];
}

-(void)loginFromViewController:(UIViewController*)viewController
             withFunctionBlock:(FunctionBlock)block
{

        [[FacebookUtility sharedInstance] loginFromViewController:viewController withFunctionBlock:^{
            FBSDKAccessToken* newToken=[[FBCache alloc] init].getFBSDKAccessToken;
            if(newToken)
            {
                [[AccountInfoCache new] saveIsLOGGEDIN:YES];
                
                NSDictionary* newProfile=[[FBCache alloc] init].getFBSDKProfile;
                NSString* fbid=[newProfile objectForKey:@"id"];
                NSString* fbname=[newProfile objectForKey:@"name"];

                if(fbid != nil && fbid.length > 0)
                {
                }
                if(fbname != nil && fbname.length > 0)
                {

                }
            }
            else{

            }
            block();
        }];
    
}

-(void)updateFBFriendsFromViewController:(UIViewController*)viewController
                       withFunctionBlock:(FunctionBlock)block
{
    FBSDKAccessToken* newToken=[[FBCache alloc] init].getFBSDKAccessToken;
    if(!newToken)
    {
        [self loginFromViewController:viewController withFunctionBlock:^{
            block();
        }];
    }
    else{
        [[FacebookUtility sharedInstance] updateFBFriensWithToken:newToken FunctionBlock:^{
            block();
        }];
    }
}

-(void)logoutWithFunctionBlock:(FunctionBlock)block
{
    [[FacebookUtility sharedInstance] logoutWithFunctionBlock:^{
        //do something here.
        block();
    }];
}

-(NSMutableArray *)getFacebookContacts
{
    NSMutableArray* fbFriends=[[FBCache alloc] init].getFBFriends;
    if(!fbFriends)
    {
        return nil;
    }
    
    NSMutableArray*contacts=[NSMutableArray new];
    
    for(FBContact* fbcontact in fbFriends)
    {
        Contact* contact=[Contact new];
        
        NSArray* firstLastStrings = [fbcontact.name componentsSeparatedByString:@" "];
        NSString* lastname = @"";
        NSString* firstname = @"";
        
        for (int j=0;j<firstLastStrings.count;j++) {
            if (j == firstLastStrings.count - 1) {
                lastname = [firstLastStrings objectAtIndex:j];
            } else {
                firstname = [firstname stringByAppendingString:[firstLastStrings objectAtIndex:j]];
                // If there are other first names to add, add a string
                if ((j+2) != firstLastStrings.count) firstname = [firstname stringByAppendingString:@" "];
            }
        }
        
        contact.firstname=firstname;
        contact.lastname=lastname;
        contact.email=fbcontact.email;
        contact.fbID=fbcontact.id;
        contact.ischeckd=@"no";
        [contacts addObject:contact];
    }
    return contacts;
}
@end

