//
//  SyncJWWebService.m
//
//  Created by DesenGuo on 2016-02-10.
//

#import <Foundation/Foundation.h>
#import "SyncWebService.h"

static SyncJWWebService *_sharedInstance;

@implementation SyncJWWebService
{
    id httpResult;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [SyncJWWebService new];
    });
    return _sharedInstance;
}
- (id)executeWebServiceApi:(NSString *)apiName
            withParameters:(NSMutableDictionary*)paramDict
                withTarget:(id)target
                     isGET:(Boolean) isGET
                hasTimeout:(Boolean) hasTimeout
                    hasGIF:(Boolean) hasGIF

{
    NSLog(@"Web Service API to execute is [%@]", apiName);
    NSString *baseURL = WEB_API_URL;
    
    NSString *queryString = [self createQueryString:paramDict];
    NSString *getRequestUrl;
    
    NSString *apiString;
    
    if (queryString != nil && queryString.length > 0)
    {
        apiString = [NSString stringWithFormat:@"%@%@",
                     apiName, queryString];
        getRequestUrl = [NSString stringWithFormat:@"%@%@",
                         baseURL, apiString];
    }
    else
    {
        apiString = [NSString stringWithFormat:@"%@",
                     apiName];
        getRequestUrl = [NSString stringWithFormat:@"%@%@",
                         baseURL, apiString];
    }
    NSLog(@"apiString=[%@]", apiString);
    NSLog(@"REQUEST : %@",getRequestUrl);
    
    ////------get
    if(isGET)
    {
        self.connection = [[HTTPConnection alloc]initWithURL:getRequestUrl];
        self.connection.hasGIF=hasGIF;
        self.connection.hasTimeout=hasTimeout;
        httpResult=[self.connection startHTTPGetRequestWithTarget:target];
    }
    ////------post
    else{
        self.connection = [[HTTPConnection alloc] initWithURL:baseURL];
        self.connection.hasGIF=hasGIF;
        self.connection.hasTimeout=hasTimeout;
        httpResult=[self.connection startHTTPPostRequestWithTarget:target post:apiString url:baseURL];

    }

    return httpResult;
}

- (NSString *)createQueryString:(NSMutableDictionary *)parameters
{
    NSMutableString *queryString = [[NSMutableString alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //format output:  such as for date “Tuesday, April 12, 1952 AD” or for time “3:30:42pm PST”.
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    
    //bool firstTime = true;
    for (NSString *key in parameters.allKeys)
    {
        NSString *value = [NSString stringWithFormat:@"%@",[parameters valueForKey:key]];
        if (value != nil && value.length > 0)
        {	  [queryString appendString:@"&"];
            
            NSString *urlEncodedValue =
            [value urlEncodeUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"parameter name=[%@], value before url encode=[%@], value after url encode=[%@]",
                  key, value, urlEncodedValue);
            
            [queryString appendFormat:@"%@=%@", key, urlEncodedValue];
            //firstTime = false;
        }
    }
    
    return queryString;
}

@end