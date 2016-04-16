//
//  TokenStorage.m
//  TwitterVideoUploader
//
//  Created by Karen Ovsepyan on 10/22/15.
//  Copyright © 2015 ITLock. All rights reserved.
//

#import "TokenStorage.h"

static NSString* tokenKey = @"twitterToken";
static NSString* secretKey = @"twitterSecret";
static NSString* userIDKey = @"twitterUserID";
static NSString* usernameKey = @"twitterUsername";
@implementation TokenStorage

+(instancetype)sharedStorage{
        static dispatch_once_t pred;
        static TokenStorage *shared = nil;
        dispatch_once(&pred, ^{
            shared = [[TokenStorage alloc] init];
        });
    return shared;
}

-(void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:tokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setSecret:(NSString *)secret{
    [[NSUserDefaults standardUserDefaults] setValue:secret forKey:secretKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserID:(NSString *)userID{
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:userIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setUsername:(NSString *)username{
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:usernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)token{
    return [[NSUserDefaults standardUserDefaults]stringForKey:tokenKey];
}

-(NSString*)secret{
    return [[NSUserDefaults standardUserDefaults]stringForKey:secretKey];
}

-(NSString*)userID{
    return [[NSUserDefaults standardUserDefaults]stringForKey:userIDKey];
}
-(NSString*)username{
    return [[NSUserDefaults standardUserDefaults]stringForKey:usernameKey];
}
-(BOOL)tokenize
{
    return self.token.length > 0 && self.secret.length > 0;
}

-(void)removeTokens{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tokenKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:secretKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:usernameKey];
}

@end
