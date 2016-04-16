//
//  URLRequestResponseStatus.m
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import "URLRequestResponseStatus.h"

@implementation URLRequestResponseStatus

@synthesize statusCode, statusMessage,userMessage;

- (id)initWithStatusCode:(NSNumber *)status
                statusMessage:(NSString *)statusDescriptionMessage
             displayedMessage:(NSString *)displayedMessage
{
  self = [super init];
  if (self)
  {
    @try
    {
      statusCode = [NSString stringWithFormat:@"%@",status];
      statusMessage = statusDescriptionMessage;
      userMessage = displayedMessage;
    }
    @catch (NSException *exception)
    {
      NSLog(@"Fail to init the URLRequestReponseStatus, exception :[%@]", exception);
    }
    @finally
    {
    }

  }
  return self;
}


@end
