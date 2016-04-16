//
//  SideBarDemoViewController.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import "SideBarDemoViewController.h"

@implementation SideBarDemoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
        
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [ResourceHelper updateRuntimeAddressBook];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end
