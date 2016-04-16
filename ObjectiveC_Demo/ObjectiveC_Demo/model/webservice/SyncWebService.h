//
//  SyncJWWebService.h
//
//  Created by DesenGuo on 2016-02-10.
//

#import "AppConstants.h"
#import "HTTPConnection.h"
#import "WebServiceConstant.h"
#import "NSString+URLEncoding.h"
#import "URLRequestResponseStatus.h"



#ifndef SyncJWWebService_h
#define SyncJWWebService_h


#endif /* SyncJWWebService_h */

@interface SyncJWWebService : NSObject
{
}
+(SyncJWWebService*)sharedInstance;

- (id)executeWebServiceApi:(NSString *)apiName
            withParameters:(NSMutableDictionary*)paramDict
                withTarget:(id)target
                     isGET:(Boolean) isGET
                hasTimeout:(Boolean) hasTimeout
                    hasGIF:(Boolean) hasGIF;

@property (atomic, strong) HTTPConnection *connection;
@end