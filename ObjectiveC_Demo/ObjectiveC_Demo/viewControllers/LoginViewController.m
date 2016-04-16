//
//  LoginViewController.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-25.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if([[AccountInfoCache new] getIsLOGGEDIN])
    {
        [Navigator pushViewControllerFromCurrentViewController:self withViewControllerIDName:@"MyPageViewController" andAnimated:NO];        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"");
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    
}

#pragma mark - button onClick
- (IBAction)actionFacebookLogin:(id)sender {

    if([self checkFacebookLogin])
    {
        return;
    }
    if([Connectivity isNetConnectWithMessageFromViewController:self])
    {
        [[FacebookHelper sharedInstance] loginFromViewController:self withFunctionBlock:^{
            [self checkFacebookLogin];
        }];
    }
}

-(BOOL)checkFacebookLogin
{
    if([[FacebookHelper sharedInstance] isFacebookLoggedIn])
    {
        [Navigator pushViewControllerFromCurrentViewController:self withViewControllerIDName:@"MyPageViewController"  andAnimated:YES];
        return YES;
    }
    return NO;
}
@end
