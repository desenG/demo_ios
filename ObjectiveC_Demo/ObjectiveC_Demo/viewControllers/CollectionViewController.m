//
//  ViewController.m
//  test
//
//  Created by Andrey Filipenkov on 06.07.14.
//  Copyright (c) 2014 Andrey Filipenkov. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource, *originalDataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController
{
//    UISearchBar* searchBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.titleView.frame.size.width, 44.0f)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [self.titleView addSubview:searchBar];
//    self.navigationItem.titleView = searchBar;
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];

    self.dataSource = [NSMutableArray arrayWithCapacity:30];
    for (NSUInteger i = 0; i < 30; ++i) {
        [self.dataSource addObject:[NSString stringWithFormat:@"cell %u", i]];
    }
    self.originalDataSource = self.dataSource;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [(UILabel *)cell.contentView.subviews[0] setText:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self applyFilters:[NSSet setWithObject:searchBar.text]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText length]) {
        self.dataSource = self.originalDataSource;
        [self.collectionView reloadData];
    }
    else{
        [self applyFilters:[NSSet setWithObject:searchBar.text]];
    }
}


- (void)applyFilters:(NSSet *)filters {
    NSMutableArray *newData = [NSMutableArray array];
    for (NSString *s in self.dataSource) {
        for (NSString *filter in filters) {
            if ([s rangeOfString:filter].location != NSNotFound) {
                [newData addObject:s];
                break;
            }
        }
    }
    self.dataSource = newData;
    
    [self.collectionView reloadData];
}
@end
