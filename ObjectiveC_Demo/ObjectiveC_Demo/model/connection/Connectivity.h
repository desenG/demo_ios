//
//  Connectivity.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-25.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Alert.h"
#define LostConnectivityNotification @"LostConnectivityNotification"
@interface Connectivity : NSObject
@property (nonatomic, retain) Reachability* internetReach;
+(Connectivity*)sharedInstance;
+(bool) isNetConnect;
+(bool) isNetConnectWithMessageFromViewController:(UIViewController *) currentViewController;
+(bool) isNetConnectWithDialogFromViewController:(UIViewController *) currentViewController;
-(void)addConnectonListener;
- (void) reachabilityChanged: (NSNotification* )note;
@end
