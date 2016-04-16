//
//  TokenStorage.h
//  TwitterVideoUploader
//
//  Created by Karen Ovsepyan on 10/22/15.
//  Copyright © 2015 ITLock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenStorage : NSObject

+(instancetype)sharedStorage;

@property (nonatomic,strong) NSString* token;
@property (nonatomic,strong) NSString* secret;
@property (nonatomic,strong) NSString* userID;
@property (nonatomic,strong) NSString* username;
-(BOOL)tokenize;

-(void)removeTokens;

@end
