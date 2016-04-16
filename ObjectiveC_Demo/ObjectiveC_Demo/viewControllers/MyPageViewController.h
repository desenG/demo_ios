//
//  PageViewController.h
//
//

#import <UIKit/UIKit.h>
#import "PBJViewController.h"

@interface MyPageViewController : UIPageViewController <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *_viewControllers;
@property NSInteger currentPage;

typedef NS_ENUM(NSUInteger, PageType)  {
    PAGE_SIDEMENU,
    PAGE_PBJ,
    PAGE_TAB,
    PAGE_SLIDE
};
@end
