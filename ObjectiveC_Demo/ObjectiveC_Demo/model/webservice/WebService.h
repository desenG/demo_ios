//
//  WebService.h
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//
#import "TypeDefinition.h"
#import "HTTPConnection.h"
#import "NSString+URLEncoding.h"

@interface WebService : NSObject
{
    UIAlertController *timeAlert;
}

+(WebService*)sharedInstance;
- (void)executeWebServiceApi:(NSString *)apiName
              withParameters:(NSMutableDictionary*)paramDict
         withSuccessSelector:(SEL)successSelector
          withFailedSelector:(SEL)failedSelector
                  withTarget:(id)target
                       isGET:(Boolean) isGET
                  hasTimeout:(Boolean) hasTimeout
            timeoutAlertType:(NSUInteger) timeoutAlertType
                      hasGIF:(Boolean) hasGIF;
- (void)executeWebServiceApi:(NSString *)apiName
              withParameters:(NSMutableDictionary*)paramDict
         withSuccessSelector:(SEL)successSelector
          withFailedSelector:(SEL)failedSelector
 andGetDataCompletitionBlock:(GetDataCompletitionBlock)failedHandler
                  withTarget:(id)target
                       isGET:(Boolean) isGET
                  hasTimeout:(Boolean) hasTimeout
                      hasGIF:(Boolean) hasGIF;
@end
