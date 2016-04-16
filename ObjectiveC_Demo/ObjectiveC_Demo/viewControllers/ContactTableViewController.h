//
//  MyTableViewController.h
//  test
//
//  Created by Duncan Champney on 2/15/13.
//  Copyright (c) 2013 Duncan Champney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticTableParentProtocol.h"
#import "StaticTableViewControllerProtocol.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "Alert.h"
#import "AppDelegate.h"
#import "NSString+Modify.h"

@interface ContactTableViewController : UITableViewController <StaticTableViewControllerProtocol,UISearchResultsUpdating, UISearchBarDelegate>

{
}

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, weak) UIViewController <StaticTableParentProtocol> *delegate;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results

-(void)updateTable;

@end
