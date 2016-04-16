//
//  SidebarTableViewController.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import "SidebarTableViewController.h"

@implementation SidebarTableViewController
{
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"title", @"sidemenuitem1", @"sidemenuitem2", @"sidemenuitem3", @"sidemenuitem4", @"sidemenuitem5", @"sidemenuitem6", @"sidemenuitem7"];
}
- (IBAction)actionLogout:(id)sender {
    [[FacebookHelper sharedInstance] logoutWithFunctionBlock:^{
        [[AccountInfoCache new] removeIsLOGGEDIN];
        [Navigator goToRootViewController:self withAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 100;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(indexPath.row==0)
    {
        UIButton *btnprofile = (UIButton *)[cell viewWithTag:1000];
        UILabel *labelName = (UILabel *)[cell viewWithTag:1001];
        labelName.text=[[[FBCache alloc] init].getFBSDKProfile objectForKey:@"name"];
        [self setFBImageAsDefaultPicInBtnProfile:btnprofile];
        [cell.contentView addSubview:btnprofile];
        [cell.contentView addSubview:labelName];
    }
    return cell;
}

- (void) setFBImageAsDefaultPicInBtnProfile: (UIButton *)btnprofile{
    ProfileHelper * profileHelper = [ProfileHelper new];
//    if([profileHelper getSavedProfileImage])
//    {
//        [btnprofile setImage:[profileHelper getSavedProfileImage] forState:UIControlStateNormal];
//        return;
//    }
    NSString* fbid=[[[FBCache alloc] init].getFBSDKProfile objectForKey:@"id"];
    
    __block UIImage *fbProfileImage = nil;
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=80&&height=80", fbid];
    
    fbProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    if (fbProfileImage) {
        
        NSData *pngImageData = UIImagePNGRepresentation(fbProfileImage);
        
        if(pngImageData) {
            if([profileHelper saveProfileImageAsTempFile:pngImageData]) {
                
                // add the image to the button
                [btnprofile setImage:fbProfileImage forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
}
@end
