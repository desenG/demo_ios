//
//  PageViewController.m
//
//

#import "MyPageViewController.h"
@implementation MyPageViewController
{
    UIStoryboard *mainStoryboard;
}

@synthesize _viewControllers,currentPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"MyPageViewController - viewWillAppear");
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView* scrollView=(UIScrollView*)view;
            [scrollView setDelegate:self];
        }
    }
    
    mainStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    _viewControllers = [[NSMutableArray alloc]init];
    
    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"]];
  
    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"PBJViewController"]];

    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"TabMenuDemo"]];
    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"SlideShowDemoViewController"]];
    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectionViewController"]];
    [_viewControllers addObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"TablesDemoViewController"]];

    [self setViewControllers:@[_viewControllers[PAGE_SIDEMENU]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    self.dataSource = self;
    self.delegate = self;
}

- (UIViewController*)viewControllerForPageNumber:(NSUInteger)pageNumber
{
    NSLog(@"viewControllerForPageNumber--->%lu",(unsigned long)pageNumber);
    if (pageNumber < _viewControllers.count)
    {
        //currentPage = pageNumber;
        return _viewControllers[pageNumber];
    }
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    currentPage = currentIndex;
    return [self viewControllerForPageNumber:--currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    currentPage = currentIndex;
    return [self viewControllerForPageNumber:++currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [_viewControllers indexOfObject:pageViewController];
}

-(void)setScrollEnabled:(BOOL)enabled forPageViewController:(UIPageViewController*)pageViewController{
    for(UIView* view in pageViewController.view.subviews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView* scrollView=(UIScrollView*)view;
            [scrollView setScrollEnabled:enabled];
            return;
        }
    }
}
#pragma mark - UIScrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 == currentPage && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (currentPage == [_viewControllers count]-1 && scrollView.contentOffset.x > scrollView.bounds.size.width)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (0 == currentPage && scrollView.contentOffset.x <= scrollView.bounds.size.width)
    {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (currentPage == [_viewControllers count]-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

-(void)setscrollenable: (BOOL)isEnable
{
     [self setScrollEnabled:isEnable forPageViewController:self];
}
@end
