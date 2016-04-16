//
//
//  Created by DesenGuo on 2016-01-30.
//

#import <Foundation/Foundation.h>
#import "Enumrations.h"

// For amazon downloading process
NSString *const AWSDownloadingStatusName[5] = {
    [GOTNEWDATA] = @"GOTNEWDATA",
    [DOWNLOADSTART] = @"DOWNLOADSTART",
    [DOWNLOADSTOP] = @"DOWNLOADSTOP",
    [NOGOTDATA] = @"NOGOTDATA",
    [AITEMDOWNLOADED] = @"AITEMDOWNLOADED"
};