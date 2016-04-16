//
//  JSONHTTPConnection.m
//  
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//

#import "HTTPConnection.h"
#import "URLRequestResponseStatus.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation HTTPConnection
{
  NSURL *requestURL;
  NSURLRequest *request;
  NSURLConnection *connectionWithRequest;
  NSMutableData *connResponseData;
  SEL successSelector;
  SEL failureSelector;
  NSObject *targetObject;
  UIViewController *targetViewController;
  NSNumber *status;
  NSArray *jsonArray;
  URLRequestResponseStatus *responseStatus;
  UIAlertController *timeAlert;
  UIAlertController *reachabilityAlert;
}
@synthesize hasGIF;
@synthesize hasTimeout;
@synthesize timeoutTimer;
@synthesize timeoutAlertType;



- (id)initWithURL:(NSString *)urlString
{
  self = [super init];
  
  if(self)
  {
    hasGIF=false;
    hasTimeout=false;
    timeoutTimer=nil;
    timeoutAlertType= MESSAGE_W_WAIT_CANCEL;
    requestURL = [NSURL URLWithString:urlString];
    connResponseData = [[NSMutableData alloc]init];
    responseStatus = [[URLRequestResponseStatus alloc]init];
  }
  
  return self;
}


- (id)initWithURLRequest:(NSURLRequest *)url
{
  self = [super init];
  
  if(self)
  {
    hasGIF=false;
    hasTimeout=false;
    timeoutTimer=nil;
    timeoutAlertType= MESSAGE_W_WAIT_CANCEL;
    request = url;
    connResponseData = [[NSMutableData alloc]init];
    responseStatus = [[URLRequestResponseStatus alloc]init];
  }
  
  return self;
}

-(NSData *)startHTTPGetRequestWithTarget:(id)target
{
    successSelector = nil;
    failureSelector = nil;
    targetObject = target;
    targetViewController=target;
    NSData* result;
    
    request =[NSURLRequest requestWithURL:requestURL
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                          timeoutInterval:15.0];
    
    bool canStartRequest = false;
    
    if ([NSURLConnection canHandleRequest:request])
    {
        NSLog(@"URL request for %@ can be started", request);
        canStartRequest = true;
    }
    else
    {
        NSLog(@"URL request for %@ CANNOT be started", request);
        NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                    code:100
                                                userInfo:nil];
        NSLog(@"Error : %@", error);
        result=nil;
    }
    
    if (canStartRequest)
    {
        NSLog(@"NSURLConnection Works!");
        
        @try
        {
            NSURLResponse* response;
            NSError* error = nil;
            //Capturing server response
            result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
    }
    else
    {
        NSLog(@"NSURLConnection can not work");
        result=nil;
    }
    return result;
}

-(NSData *)startHTTPPostRequestWithTarget:(id)target
                                     post:(NSString *)postString
                                      url:(NSString*)urlString
{
    successSelector = nil;
    failureSelector = nil;
    targetObject = target;
    targetViewController=target;
    NSData* result;
    
    NSMutableURLRequest* postrequest =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [postrequest setHTTPMethod:@"POST"];
    [postrequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [postrequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    bool canStartRequest = false;
    
    if ([NSURLConnection canHandleRequest:postrequest])
    {
        NSLog(@"URL request for %@ can be started", postrequest);
        canStartRequest = true;
    }
    else
    {
        NSLog(@"URL request for %@ CANNOT be started", postrequest);
        NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                    code:100
                                                userInfo:nil];
        NSLog(@"Error : %@", error);
        result=nil;
    }
    
    if (canStartRequest)
    {
        NSLog(@"NSURLConnection Works!");
        
        @try
        {
            NSURLResponse* response;
            NSError* error = nil;
            //Capturing server response
            result = [NSURLConnection sendSynchronousRequest:postrequest
                                           returningResponse:&response
                                                       error:&error];        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
    }
    else
    {
        NSLog(@"NSURLConnection can not work");
        result=nil;
    }
    return result;
}

-(void)startJSONHTTPRequestWithSuccessSelector:(SEL)successSel 
                           failureSelector:(SEL)failureSel
                              targetObject:(id)target
{
  successSelector = successSel;
  failureSelector = failureSel;
  targetObject = target;
  targetViewController=target;
  
  //the reason to use 240 because we want to make timeout equal to postRequestWithURL(always 240 second)
  request =[NSURLRequest requestWithURL:requestURL
                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                 timeoutInterval:240.0];
  
  bool canStartRequest = false;
  
  if ([NSURLConnection canHandleRequest:request])
  {
    NSLog(@"URL request for %@ can be started", request);
    canStartRequest = true;
  }
  else
  {
    NSLog(@"URL request for %@ CANNOT be started", request);
    NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                code:100
                                            userInfo:nil];
    NSLog(@"Error : %@", error);
    return;
  }
  
  if (canStartRequest)
  {
    NSLog(@"NSURLConnection Works!");
      if(hasGIF)
      {
          [GiFHUD showWithOverlay];
          if(hasTimeout)
          {
              timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(tapTimerFired:) userInfo:nil repeats:NO];
          }
      }
      else{
          if(hasTimeout)
          {
              timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(anothertapTimerFired:) userInfo:nil repeats:NO];
          }
      }
      
      @try
      {
          connectionWithRequest = [[NSURLConnection alloc]initWithRequest:request delegate:self];
          self.backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
              // Cancel the connection
              NSLog(@"From background process.");
              [connectionWithRequest cancel];
          }];
      }
      @catch (NSException *exception) {
          NSLog(@"%@",exception);
      }
     
    
  }
  else
  {
    NSLog(@"NSURLConnection can not work");
    NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                code:150
                                            userInfo:nil];
    responseStatus = [responseStatus initWithStatusCode:[NSNumber numberWithInteger:[error code]]
                                          statusMessage:[error description]
                                       displayedMessage:NSLocalizedString(@"URLConnectionError", @"")];
    if (targetObject != nil && failureSelector !=nil)
    {
    @try
    {
      SuppressPerformSelectorLeakWarning([targetObject performSelector:failureSelector
                                                            withObject:nil 
                                                            withObject:responseStatus]);
    }
    @catch (NSException *exception)
    {
      NSLog(@"NSURLConnection catch a exception :%@"
            ,exception);
    }
    @finally
    {
      NSLog(@"statusCode = %ld",(long)[error code]);
    }
    }
    return;
  }
  
}

-(void)startUploadOfFile:(SEL)successSel
         failureSelector:(SEL)failureSel
            targetObject:(id)target
{

  successSelector = successSel;
  failureSelector = failureSel;
  targetObject = target;
  targetViewController=target;

  
  bool canStartRequest = false;
  
  if ([NSURLConnection canHandleRequest:request])
  {
    NSLog(@"URL request for %@ can be started", request);
    canStartRequest = true;
  }
  else
  {
    NSLog(@"URL request for %@ CANNOT be started", request);
    NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                code:100
                                            userInfo:nil];
    NSLog(@"Error : %@", error);
    return;
  }
  
  if (canStartRequest)
  {
    NSLog(@"NSURLConnection Works!");
    if(hasGIF)
    {
        [GiFHUD showWithOverlay];
        if(hasTimeout)
        {
            timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(tapTimerFired:) userInfo:nil repeats:NO];
        }
    }
      
    connectionWithRequest = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
          // Cancel the connection
          NSLog(@"From background process.");
          [connectionWithRequest cancel];
      }];
  }
  else
  {
    NSLog(@"NSURLConnection can not work");
    NSError *error = [[NSError alloc] initWithDomain:@"connection"
                                                code:150
                                            userInfo:nil];
    responseStatus = [responseStatus initWithStatusCode:[NSNumber numberWithInteger:[error code]]
                                          statusMessage:[error description]
                                       displayedMessage:NSLocalizedString(@"URLConnectionError", @"")];
    if (targetObject != nil && failureSelector !=nil)
    {
    @try
    {
      SuppressPerformSelectorLeakWarning([targetObject performSelector:failureSelector
                                                            withObject:nil
                                                            withObject:responseStatus]);
    }
    @catch (NSException *exception)
    {
      NSLog(@"NSURLConnection catch a exception :%@"
            ,exception);
    }
    @finally
    {
      NSLog(@"statusCode = %ld",(long)[error code]);
    }
    }
    return;
  }
  
  
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  NSLog(@"Receving data correctly ::%d",[data length]);
  [connResponseData appendData:data];
    if(hasTimeout && timeoutTimer!=nil)
    {
        [timeoutTimer invalidate];
        timeoutTimer=nil;
    }
    if(timeAlert!=nil)
    {
        [timeAlert dismissViewControllerAnimated:YES completion:nil];
        timeAlert=nil;
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    }
    if(hasGIF)
    {
        [GiFHUD dismiss];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(hasTimeout && timeoutTimer!=nil)
    {
        [timeoutTimer invalidate];
        timeoutTimer=nil;
    }
    if(timeAlert!=nil)
    {
        [timeAlert dismissViewControllerAnimated:YES completion:nil];
        timeAlert=nil;
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    }
    if(hasGIF)
    {
        [GiFHUD dismiss];
    }
    
  if ([response isKindOfClass:[NSHTTPURLResponse class]])
  {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    status = [NSNumber numberWithInt:httpResponse.statusCode];
    NSLog(@"HTTP didReceiveResponse status code of response is %@", status);
    NSLog(@"HTTP Content-Length of response is %@",  [[httpResponse allHeaderFields] valueForKey:@"Content-Length"]);
  }
  else
  {
    NSLog(@"Can not ReceiveResponse from the Server");
    return;
  }
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSLog(@"Finish loading the data from the backend");
    NSLog(@"Data ::%@",[[NSString alloc] initWithData:connResponseData encoding:NSASCIIStringEncoding]);
   
  if([self completitionBlock])
        [self completitionBlock](connResponseData,nil);
    
  NSError *error = nil;
  
  @try
  {
    jsonArray = [NSJSONSerialization JSONObjectWithData:connResponseData
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&error];
    if (!jsonArray)
    {
        NSMutableArray *dummyArray = [[NSMutableArray alloc] init];
        NSString *resultData = [[NSString alloc] initWithData:connResponseData encoding:NSUTF8StringEncoding];
          
        [dummyArray addObject:resultData];
        jsonArray = [dummyArray copy];
    }

  }
  @catch (NSException *exception)
  {
    NSLog(@"NSJSONSerialization catch an exception : [%@]", exception);
  }
  @finally
  {
  }

  NSLog(@"Data received as NSString:\n[%@]", jsonArray);
  
  if ([status integerValue] == 200 && connResponseData !=nil)
  {
    if (!jsonArray)
    {
      NSLog(@"Error parsing JSON: [%@]", error);
      responseStatus = [responseStatus initWithStatusCode:[NSNumber numberWithInteger:[error code]]
                                            statusMessage:[error description]
                                         displayedMessage:NSLocalizedString(@"errorMessageForParseError", @"")];
    if (targetObject != nil && failureSelector !=nil)
    {
      @try
      {
        SuppressPerformSelectorLeakWarning([targetObject performSelector:failureSelector
                                                              withObject:jsonArray
                                                              withObject:responseStatus]);
      }
      @catch (NSException *exception)
      {
        NSLog(@"performFailureSelector for code 200 in connectionDidFinishLoading caught a exception :%@"
              ,exception);
      }
      @finally
      {
        NSLog(@"statusCode = %ld , jsonArrayReceived = %@",(long)status,jsonArray);
      }
    }
    }
    
    else
    {
      responseStatus = [responseStatus initWithStatusCode:status
                                            statusMessage:NSLocalizedString(@"successMessage", @"")
                                         displayedMessage:NSLocalizedString(@"successMessage", @"")];
    if (targetObject != nil && successSelector !=nil)
    {
      @try
      {
        SuppressPerformSelectorLeakWarning([targetObject performSelector:successSelector
                                                              withObject:jsonArray
                                                              withObject:responseStatus]);
      }
      @catch (NSException *exception)
      {
        NSLog(@"performSuccessSelector for code 200 in connectionDidFinishLoading caught a exception :%@"
              ,exception);
      }
    }
      
    }
  }
  else //For which HTTP response status code is not equal to 200.
  {
    NSLog(@"Cannot get the Data from the server");
    responseStatus = [responseStatus initWithStatusCode:[NSNumber numberWithInteger:[error code]]
                                          statusMessage:[error description]
                                       displayedMessage:NSLocalizedString(@"failToRetrieveDataFromServer", @"")];
    if (targetObject != nil && failureSelector !=nil)
    {
    @try
    {
      SuppressPerformSelectorLeakWarning([targetObject performSelector:failureSelector
                                                            withObject:jsonArray
                                                            withObject:responseStatus]);
    }
    @catch (NSException *exception)
    {
      NSLog(@"performFailureSelector for code 400 in connectionDidFinishLoading caught a exception :%@"
            ,exception);
    }
    }
  }
     [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
}

//If fail, return nil and an error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([self completitionBlock])
        [self completitionBlock](nil,error);
    if(hasTimeout && timeoutTimer!=nil)
    {
        [timeoutTimer invalidate];
        timeoutTimer=nil;
    }
    if(timeAlert!=nil)
    {
        [timeAlert dismissViewControllerAnimated:YES completion:nil];
        timeAlert=nil;
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    }
    if(hasGIF)
    {
        [GiFHUD dismiss];
        if(reachabilityAlert==nil)
        {
            reachabilityAlert = [UIAlertController alertControllerWithTitle:MESSAGE_CONNECTION_ERROR message:MESSAGE_CONNECTION_ERROR_MSG
                                                             preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* OK = [UIAlertAction
                                 actionWithTitle:MESSAGE_OK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [reachabilityAlert dismissViewControllerAnimated:YES completion:nil];
                                     reachabilityAlert=nil;
                                    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                                 }];
            [reachabilityAlert addAction:OK];
        }
        
        [self showAlertController:reachabilityAlert];
    }
  NSLog(@"Connection for url [%@] failed.", [connection description]);
  NSLog(@"Error Code: %ld Error: %@", (long)[error code],[error description]);
  
  responseStatus = [responseStatus initWithStatusCode:[NSNumber numberWithInteger:[error code]]
                                        statusMessage:[error description]
                                     displayedMessage:NSLocalizedString(@"failToRetrieveDataFromServer", @"")];
  
  if (targetObject != nil && failureSelector !=nil)
  {
    @try
    {
      SuppressPerformSelectorLeakWarning([targetObject performSelector:failureSelector
                                                            withObject:jsonArray
                                                            withObject:responseStatus]);
    }
    @catch (NSException *exception)
    {
      NSLog(@"performFailureSelector in connectionDidFailWithError caught a exception :%@", exception);
    }
    @finally
    {
    }
  }
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
}

- (void)abortConnection
{
  @try
  {
    if (connectionWithRequest!=nil)
    {
      [connectionWithRequest cancel];
      NSLog(@"connection cancelled");
    }
    else
    {
      NSLog(@"Abort connection failed, the connectionWithRequest do not have value");
    }
  }
  @catch (NSException *exception)
  {
    NSLog(@"Exception caught in Abort Connection : %@",exception);
  }
  @finally
  {
  }
  
}
- (void)finalTimerFired:(NSTimer *)aTimer
{
    [timeAlert dismissViewControllerAnimated:YES completion:nil];
    timeAlert=nil;
    [self abortConnection];
    if([self completitionBlock])
        [self completitionBlock](nil,nil);
    [GiFHUD dismiss];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    if(reachabilityAlert==nil)
    {
        reachabilityAlert = [UIAlertController alertControllerWithTitle:MESSAGE_CONNECTION_ERROR message:MESSAGE_CONNECTION_ERROR_MSG
                                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* OK = [UIAlertAction
                             actionWithTitle:MESSAGE_OK
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [reachabilityAlert dismissViewControllerAnimated:YES completion:nil];
                                 reachabilityAlert=nil;
                                 [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                             }];
        [reachabilityAlert addAction:OK];
    }
    
    [self showAlertController:reachabilityAlert];
}

//anothertapTimerFired
- (void)anothertapTimerFired:(NSTimer *)aTimer
{
    [self abortConnection];
    if([self completitionBlock])
        [self completitionBlock](nil,nil);
}

- (void)tapTimerFired:(NSTimer *)aTimer
{
    if(!hasGIF)//It is a silent request. Therefore, timeout means continuing waiting. Dont show timeout alert.
    {
        return;
    }
    
    //user is waiting with gifhud
    //and timeout
    if(timeAlert==nil)
    {
        switch (timeoutAlertType) {
            case MESSAGE_W_OK:
            {
                timeAlert = [UIAlertController alertControllerWithTitle:MESSAGE_CONNECTION_ERROR
                                                                message: MESSAGE_CONNECTION_SLOW_OK_MSG
                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:MESSAGE_OK
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [timeAlert dismissViewControllerAnimated:YES completion:nil];
                                         timeAlert=nil;
                                         [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                                         [GiFHUD display];
                                         
                                     }];
                [timeAlert addAction:ok];
                break;
            }
            default://MESSAGE_W_WAIT_CANCEL
            {
                timeAlert = [UIAlertController alertControllerWithTitle:MESSAGE_CONNECTION_ERROR
                                                                message:MESSAGE_CONNECTION_SLOW_WAIT_CANCEL_MSG
                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* wait = [UIAlertAction
                                       actionWithTitle:MESSAGE_WAIT
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [timeAlert dismissViewControllerAnimated:YES completion:nil];
                                           timeAlert=nil;
                                           [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                                           [GiFHUD display];
                                           //another 15 second, because default timeout value 240 is too long.
                                           timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(finalTimerFired:) userInfo:nil repeats:NO];
                                       }];
                
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:MESSAGE_CANCEL
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [timeAlert dismissViewControllerAnimated:YES completion:nil];
                                             timeAlert=nil;
                                             [self abortConnection];
                                             if([self completitionBlock])
                                                 [self completitionBlock](nil,nil);
                                             [GiFHUD dismiss];
                                             [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                                         }];
                [timeAlert addAction:wait];
                [timeAlert addAction:cancel];
                break;
            }
        }

    }
    [self showAlertController:timeAlert];
}

- (UIWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *viewController = [[UIViewController alloc] init];
        _alertWindow.rootViewController = viewController;
    }
    
    return _alertWindow;
}

-(void)showAlertController:(UIAlertController*)alertController
{
    if(targetViewController!=nil)
    {
        [self.alertWindow makeKeyAndVisible];
        [self.alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        [GiFHUD hide];
    }
}

@end
