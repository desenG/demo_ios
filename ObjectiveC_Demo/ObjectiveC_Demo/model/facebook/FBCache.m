//
//  FBCache.m
//
//  Created by DesenGuo on 2016-02-04.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FBCache.h"

#define FBCACHE_TOKEN_KEY @"token"
#define FBCACHE_PROFILE_KEY @"profile"

@implementation FBCache

- (id)init
{
    self = [super init];
    if (self) {
        self.prefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)cleanFBCache
{
    [self removeFBSDKAccessToken];
    [self removeFBSDKProfile];
    [self removeFBFriends];
}

-(void) saveFBSDKAccessToken:(FBSDKAccessToken*) token
{
    NSData* tokenData=[NSKeyedArchiver archivedDataWithRootObject:token];
    [self.prefs setObject:tokenData forKey:@"FBSDKAccessToken"];
}

-(FBSDKAccessToken*) getFBSDKAccessToken
{
    NSData* tokenData=[self.prefs objectForKey:@"FBSDKAccessToken"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
}

-(void)removeFBSDKAccessToken
{
    [self.prefs removeObjectForKey:@"FBSDKAccessToken"];
}

-(void) saveFBSDKProfile:(NSMutableDictionary*) profile
{
    [self.prefs setObject:profile forKey:@"FBSDKProfile"];
}

-(NSMutableDictionary*) getFBSDKProfile
{
    return [self.prefs objectForKey:@"FBSDKProfile"];
}

-(void)removeFBSDKProfile
{
    [self.prefs removeObjectForKey:@"FBSDKProfile"];
}

-(void) saveFBFriends:(NSMutableArray*) friends
{
    NSData* tokenData=[NSKeyedArchiver archivedDataWithRootObject:friends];
    [self.prefs setObject:tokenData forKey:@"FBFriends"];
}

-(NSMutableArray*) getFBFriends
{
    NSData* friendsData=[self.prefs objectForKey:@"FBFriends"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:friendsData];
}

-(void)removeFBFriends
{
    [self.prefs removeObjectForKey:@"FBFriends"];
}

-(void)dealloc {
    self.prefs=nil;
}


@end