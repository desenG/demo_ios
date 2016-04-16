//
//  URLRequestResponseStatus.h
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestResponseStatus : NSObject

@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *statusMessage;
@property (nonatomic, strong) NSString *userMessage;

- (id)initWithStatusCode:(NSNumber *)status
                statusMessage:(NSString *)statusDescriptionMessage
             displayedMessage:(NSString *)displayedMessage;


@end
