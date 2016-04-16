//
//  DiveServer.h
//  DIVE2
//
//  Created by DesenGuo on 2016-02-10.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//
#import "JWWebServiceConstant.h"

#ifndef DiveServer_h
#define DiveServer_h


#endif /* DiveServer_h */
@interface DiveServer:NSObject

+(BOOL) markDiveUploadedWithDiveID:(NSString*) diveID
                         andTarget:(id) target;
+(void)refreshDataOnserverForEmail:(NSString*) email
Passwordk:(NSString*) password
UserID:(NSString*) uid
                          DeviceID:(NSString*) deviceid;
+(void)deleteContactWithOwerID:(NSString*) ownerid
       andContactID:(NSString*) userid;
@end