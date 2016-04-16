//
//  DiveServer.m
//  DIVE2
//
//  Created by DesenGuo on 2016-02-10.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncJWWebService.h"
#import "AppDelegate.h"
#import "DiveServer.h"

@implementation DiveServer

+(BOOL) markDiveUploadedWithDiveID:(NSString*) diveID
                         andTarget:(id) target
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:diveID forKey:PARAMETER_NEW_DIVEID];

    NSLog(@"Marking Dive uploaded: DiveID is %@",diveID);
    NSData * result=[[SyncJWWebService sharedInstance] executeWebServiceApi:FUNCTION_MARKDIVEUPLOADED withParameters:dict withTarget:target isGET: APPDELEGATE.isget hasTimeout:false hasGIF:false];
    
    NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSRange range = [resultString rangeOfString:@"FAIL"];

    if (range.length > 0) {
        NSLog(@"ERROR: MarkDiveUploaded %@",result);
        return NO;
    }
    NSLog(@"Dive Marked as uploaded: DiveID is %@",diveID);

    return YES;
    
}


+(void)refreshDataOnserverForEmail:(NSString*) email
                         Passwordk:(NSString*) password
                            UserID:(NSString*) uid
                          DeviceID:(NSString*) deviceid
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:email forKey:PARAMETER_EMAIL];
    [dict setValue:password forKey:PARAMETER_PASSWORD];
    [dict setValue:uid forKey:PARAMETER_USERID];
    [dict setValue:deviceid forKey:PARAMETER_DEVICEID];
    [[JWWebService sharedInstance] executeWebServiceApi:FUNCTION_REFRESHDIVEITEMS
                                         withParameters:dict
                                    withSuccessSelector:nil
                                     withFailedSelector:nil
                                             withTarget:self
                                                  isGET:APPDELEGATE.isget];
}

+(void)deleteContactWithOwerID:(NSString*) ownerid
                  andContactID:(NSString*) userid
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ownerid forKey:PARAMETER_OWNERID];
    [dict setValue:userid forKey:PARAMETER_USERID];
    [[JWWebService sharedInstance] executeWebServiceApi:FUNCTION_DELETECONTACT
                                         withParameters:dict
                                    withSuccessSelector:nil
                                     withFailedSelector:nil
                                             withTarget:self
                                                  isGET:APPDELEGATE.isget];
}

@end

