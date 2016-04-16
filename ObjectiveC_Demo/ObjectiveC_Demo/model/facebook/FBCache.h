//
//  FBCache.h
//
//  Created by DesenGuo on 2016-02-04.
//

#ifndef FBCache_h
#define FBCache_h


#endif /* FBCache_h */
@interface FBCache: NSObject
@property (nonatomic, strong) NSUserDefaults *prefs;
-(void)cleanFBCache;
-(void) saveFBSDKAccessToken:(FBSDKAccessToken*) token;
-(FBSDKAccessToken*) getFBSDKAccessToken;
-(void)removeFBSDKAccessToken;
-(void) saveFBSDKProfile:(NSMutableDictionary*) profile;
-(NSMutableDictionary*) getFBSDKProfile;
-(void)removeFBSDKProfile;
-(void) saveFBFriends:(NSMutableArray*) friends;
-(NSMutableArray*) getFBFriends;
-(void)removeFBFriends;
@end
