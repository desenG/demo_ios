//
//  Connectivity.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-25.
//

#import "Connectivity.h"
static BOOL isNetConnect;
static Connectivity *_sharedInstance;

@implementation Connectivity
{
    
}

+(bool) isNetConnect
{
    return isNetConnect;
}

+(bool) isNetConnectWithMessageFromViewController:(UIViewController *) currentViewController
{
    if(!isNetConnect)
    {
        [Alert showMessageAlertOnCurrentViewController:currentViewController withTitle:@"Network" andMessage:@"No connection" cancelButtonTitle:@"OK"];
    }
    return isNetConnect;
}

+(bool) isNetConnectWithDialogFromViewController:(UIViewController *) currentViewController
                              executeButtonClick:(void (^)(void))executeBlock
{
    if(!isNetConnect)
    {
        [Alert showDialogOnCurrentViewController:currentViewController withTitle:@"Network" andMessage:@"No connection" cancelButtonTitle:nil executeButtonTitle:@"OK" executeButtonClick:executeBlock];
    }
    return isNetConnect;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [Connectivity new];
    });
    return _sharedInstance;
}

-(void)addConnectonListener
{
    [[NSNotificationCenter defaultCenter] addObserver: _sharedInstance selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    _sharedInstance.internetReach = [Reachability reachabilityForInternetConnection];
    [_sharedInstance.internetReach startNotifier];
    [self updateInterfaceWithReachability: _sharedInstance.internetReach];
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    
    if(curReach == _sharedInstance.internetReach)
    {
        [self setReachability: curReach];
    }
    
}

- (void) setReachability: (Reachability*) curReach
{
    NSLog(@"curReach::%@",curReach);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    isNetConnect=YES;
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;
            isNetConnect=NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            break;
        }
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }
    NSLog(@"connecton String::%@",statusString);
    if (!isNetConnect)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LostConnectivityNotification" object:nil];
    }
}


//Reachability Alert
-(void)showReachabilityAlert
{
    
}
@end
