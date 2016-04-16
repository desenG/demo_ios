//
//  WebService.m
//  VideoAppPrototype
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import "WebService.h"
static WebService *_sharedInstance;

@interface WebService()

@property (atomic, strong) HTTPConnection *connection;

- (NSString *)createQueryString:(NSMutableDictionary *)parameters;
- (void)invokeAsynchronousGET:(NSString*)path
          withSuccessSelector:(SEL)successSelector
           withFailedSelector:(SEL)failedSelector
                   withTarget:(id)target;
@end

@implementation WebService

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [WebService new];
    });
    return _sharedInstance;
}

- (void)executeWebServiceApi:(NSString *)apiName
              withParameters:(NSMutableDictionary*)paramDict
         withSuccessSelector:(SEL)successSelector
          withFailedSelector:(SEL)failedSelector
            andGetDataCompletitionBlock:(GetDataCompletitionBlock)completedHandler
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
        self.connection.completitionBlock=completedHandler;
        [self.connection startJSONHTTPRequestWithSuccessSelector:successSelector
                                                 failureSelector:failedSelector
                                                    targetObject:target];
    }
    ////------post
    else{
        NSURLRequest *request = [self postRequestWithURL:baseURL
                                                    data:nil
                                                fileName:apiString
                                                   data2:nil
                                               fileName2:nil];
        self.connection = [[HTTPConnection alloc] initWithURLRequest:request];
        self.connection.hasGIF=hasGIF;
        self.connection.hasTimeout=hasTimeout;
        [self.connection startUploadOfFile:successSelector
                           failureSelector:failedSelector
                              targetObject:target];
        
    }
}

- (void)executeWebServiceApi:(NSString *)apiName
              withParameters:(NSMutableDictionary*)paramDict
         withSuccessSelector:(SEL)successSelector
          withFailedSelector:(SEL)failedSelector
                  withTarget:(id)target
                       isGET:(Boolean) isGET
                  hasTimeout:(Boolean) hasTimeout
            timeoutAlertType:(NSUInteger) timeoutAlertType
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
        self.connection.timeoutAlertType=timeoutAlertType;
        [self.connection startJSONHTTPRequestWithSuccessSelector:successSelector
                                                 failureSelector:failedSelector
                                                    targetObject:target];
    }
    ////------post
    else{
        NSURLRequest *request = [self postRequestWithURL:baseURL
                                                    data:nil
                                                fileName:apiString
                                                   data2:nil
                                               fileName2:nil];
        self.connection = [[HTTPConnection alloc] initWithURLRequest:request];
        self.connection.hasGIF=hasGIF;
        self.connection.hasTimeout=hasTimeout;
        self.connection.timeoutAlertType=timeoutAlertType;
        [self.connection startUploadOfFile:successSelector
                           failureSelector:failedSelector
                              targetObject:target];
        
    }
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

- (void)invokeAsynchronousGET:(NSString*)path
          withSuccessSelector:(SEL)successSelector
           withFailedSelector:(SEL)failedSelector
                   withTarget:(id)target
{
  NSLog(@"QUERY : %@",path);
  self.connection = [[HTTPConnection alloc]initWithURL:path];
    
  [self.connection startJSONHTTPRequestWithSuccessSelector:successSelector
                                      failureSelector:failedSelector
                                         targetObject:target];
  
}

-(NSURLRequest *)postRequestWithURL: (NSString *)url
                               data: (NSData *)data
                           fileName: (NSString*)fileName
                              data2: (NSData *)data2
                          fileName2: (NSString*)fileName2
{
    
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[fileName length]];
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[NSData dataWithBytes:[fileName UTF8String] length:strlen([fileName UTF8String])]];
    
    return urlRequest;
}
@end
