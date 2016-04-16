//
//  JSONHTTPConnection.h
//  
//
//  Created by Antonio Atamosa Jr. on 7/15/13.
//  Copyright (c) 2013 JayR. All rights reserved.
//
#import "GiFHUD.h"
#import "Enumrations.h"
#import "MessageConstant.h"
#import "TypeDefinition.h"
@interface HTTPConnection : NSObject
  <NSURLConnectionDataDelegate,
   NSURLConnectionDelegate>

@property(nonatomic,assign)BOOL hasGIF;
@property(nonatomic,assign)BOOL hasTimeout;
@property(nonatomic,assign)NSUInteger timeoutAlertType;

@property (nonatomic,strong) NSTimer *timeoutTimer;
@property (strong, nonatomic) UIWindow *alertWindow;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;

@property (nonatomic,copy)GetDataCompletitionBlock completitionBlock;

- (id)initWithURLRequest:(NSURLRequest *)url;
- (id)initWithURL:(NSString *)urlString;
- (void)startJSONHTTPRequestWithSuccessSelector:(SEL)successSel
                            failureSelector:(SEL)failureSel
                               targetObject:(id)target;
-(NSData *)startHTTPGetRequestWithTarget:(id)target;
-(NSData *)startHTTPPostRequestWithTarget:(id)target
                                     post:(NSString *)postString
                                      url:(NSString*)urlString;
-(void)startUploadOfFile:(SEL)successSel
         failureSelector:(SEL)failureSel
            targetObject:(id)target;
- (void)abortConnection;
@end
