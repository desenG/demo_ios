//
//  FacebookUtility.m
//
//  Created by DesenGuo on 2016-02-04.
//

#import <Foundation/Foundation.h>
#import "FacebookUtility.h"

static FacebookUtility *_sharedInstance;
static FBSDKLoginManager *login;


@implementation FacebookUtility
{
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FacebookUtility new];
        login = [[FBSDKLoginManager alloc] init];
    });
    return _sharedInstance;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)isLoggedIn
{
    return[FBSDKAccessToken currentAccessToken];
}

-(void)loginFromViewController:(UIViewController*)viewController
             withFunctionBlock:(FunctionBlock)block
{
    [login logOut];
    //1.get authentication from facebook app if possible (for ios version<9)
    //2.if 1 failed, get authentication from system setting.(for all ios)
    //3.if 1 and 2 failed, open a login webview from current viewcontroller.
    if (![UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    }
    
    [login logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends"]
                 fromViewController:viewController
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
                                if (error || result.isCancelled) {
                                    NSLog(@"FacebookUtility: login failed or cancel.");
                                }
                                else
                                {
                                    NSLog(@"FacebookUtility: login successfully.");
                                    FBSDKAccessToken* token=result.token;
                                    FBCache *cache = [[FBCache alloc] init];
                                    
                                    if (token) {
                                        if (![cache.getFBSDKAccessToken isEqualToAccessToken:token]) {
                                            [cache saveFBSDKAccessToken:token];
                                            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                                            [self updateFBProfileWithToken:token FunctionBlock:^{
                                                NSLog(@"profile updated.");
                                                [self updateFBFriensWithToken:token FunctionBlock:^{
                                                    NSLog(@"Facebook friends updated.");
                                                    dispatch_semaphore_signal(sema);
                                                }];

                                            }];
                                            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                                        }
                                    }
                                    else{
                                        [cache removeFBSDKAccessToken];
                                    }
                                }
                                block();
                            }
     ];
    
}

-(void)logoutWithFunctionBlock:(FunctionBlock)block
{
    [login logOut];
    [[[FBCache alloc] init] cleanFBCache];
    block();
}

-(void)updateFBProfileWithToken:(FBSDKAccessToken*) token
FunctionBlock:(FunctionBlock)block
{    
    NSURL *nameURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me?fields=id,name,email,gender&access_token=%@",[token tokenString]]];
    NSData *retData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:nameURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0] returningResponse:nil error:nil];
    NSString *name = nil;
    NSString *strId = nil;
    NSString *strEmail = nil;
    NSString *strGender = nil;
    if (retData != nil)
    {
        NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
        NSLog(@"RESPONSE: %@",retStr);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [parser objectWithString:retStr];
        name = [dict objectForKey:@"name"];
        
        strId = [dict objectForKey:@"id"];
        
        strEmail = [dict objectForKey:@"email"];
        
        strGender = [dict objectForKey:@"gender"];
    }
    
    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
    [profile setValue:strId forKey:@"id"];
    [profile setValue:name  forKey:@"name"];
    [profile setValue:strEmail  forKey:@"email"];
    [profile setValue:strGender  forKey:@"gender"];

    FBCache *cache = [[FBCache alloc] init];
    [cache saveFBSDKProfile:profile];
    block();
}


-(void)updateFBFriensWithToken:(FBSDKAccessToken*) token
                 FunctionBlock:(FunctionBlock)block
{
    NSURL *nameURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?fields=id,name&access_token=%@",[token tokenString]]];
    NSData *retData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:nameURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0] returningResponse:nil error:nil];
    
    if(retData)
    {
        NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
        NSLog(@"RESPONSE: %@",retStr);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [parser objectWithString:retStr];
        NSArray* friends = [dict objectForKey:@"data"];
        
        NSLog(@"Found: %lu friends", (unsigned long)friends.count);
        NSMutableArray* arrayContacts = [[NSMutableArray alloc] init];
        for (int i = 0; i<friends.count; i++)
        {
            NSMutableDictionary *dict = [friends objectAtIndex:i];
            FBContact *contact = [[FBContact alloc]init];
            contact.name = [dict valueForKey:@"name"];
            contact.id = [dict valueForKey:@"id"];
            contact.email = [dict valueForKey:@"email"];
            contact.isSelected = @"no";
            [arrayContacts addObject:contact];
        }
        FBCache *cache = [[FBCache alloc] init];
        [cache saveFBFriends:arrayContacts];
    }
    block();
}
@end