//
//  ViewController.h
//  test
//
//  Created by Andrey Filipenkov on 06.07.14.
//  Copyright (c) 2014 Andrey Filipenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *titleView;
@end
