//
//  Enumrations.h
//
//  Created by DesenGuo on 2016-01-25.
//

#ifndef Enumrations_h
#define Enumrations_h


#endif /* Enumrations_h */
typedef NS_ENUM(NSUInteger, TimeoutDialogType)  {
    MESSAGE_W_OK,
    MESSAGE_W_WAIT_CANCEL
};

// For amazon downloading process
typedef enum AWSDownloadingStatus {
    GOTNEWDATA,
    DOWNLOADSTART,
    DOWNLOADSTOP,
    NOGOTDATA,
    AITEMDOWNLOADED
} AWSDownloadingStatus;

extern NSString * const AWSDownloadingStatusName[];
