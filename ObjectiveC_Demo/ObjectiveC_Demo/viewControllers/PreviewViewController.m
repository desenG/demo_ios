
//
//  PreviewViewController.m


#import "PreviewViewController.h"

@implementation PreviewViewController
{
    VIMVideoPlayer* player;
    MediaPicker* videoPicker;
    MediaPicker* imagePicker;
    UIImage* img;
    NSURL *gifURL;
}
@synthesize mediaStoragePath,moviePlayerController,playerView,btnPlayback,btnBack;

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!mediaStoragePath)
    {
        return;
    }
    if ([mediaStoragePath rangeOfString:@"mp4"].location != NSNotFound)
    {
        [self loadMoviePlayerWithFilePath:mediaStoragePath inPlayerView:playerView];
        return;
    }
    
    if ([mediaStoragePath rangeOfString:@"png"].location != NSNotFound)
    {
    }
}

-(void)viewWillDisappear:(BOOL)animated
{

    
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void)loadMoviePlayerWithFilePath:(NSString*) filePath
                       inPlayerView:(UIView *)playerView
{
    NSURL *fileURL=nil;
    fileURL    =   [NSURL fileURLWithPath:filePath];
    if(!moviePlayerController)
    {
        [self initMoviePlayerInPlayerView:playerView];
    }
    else
    {
        
    }
    player=[VIMVideoPlayer new];
    [player setURL:fileURL];
    [moviePlayerController setPlayer:player];
    [player pause];
    [self.view addSubview:moviePlayerController];
    [moviePlayerController addSubview:btnPlayback];
    [self.view bringSubviewToFront:btnPlayback];
}

-(void) initMoviePlayerInPlayerView:(UIView *)playerView
{
    moviePlayerController=[[VIMVideoPlayerView alloc] initWithFrame:CGRectMake(playerView.frame.origin.x,playerView.frame.origin.y,playerView.frame.size.width,playerView.frame.size.height)];
    moviePlayerController.translatesAutoresizingMaskIntoConstraints = NO;
    moviePlayerController.delegate = self;
    [moviePlayerController setVideoFillMode:AVLayerVideoGravityResizeAspect];
}
- (IBAction)test:(id)sender {
    // Find the resource.
    NSString *moviePath = [[NSBundle mainBundle]
                           pathForResource:@"myDemo_VS_agMobile_480p"
                           ofType:@"mov"];
    NSLog(@"video path: %@", moviePath);
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:moviePath])
    {
        [[AssetsEditor new] sendMovieFileToAlbumAtURL:movieURL];
    }
}

- (IBAction)addImg:(id)sender {
    imagePicker=[MediaPicker new];
    [imagePicker loadAssetFromViewController:self WithAssetType:(NSString*)kUTTypeImage andUIImagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum andGetDataCompletitionBlock:^(id obj, NSError *err) {
        img=(UIImage*)obj;
        if (img) {
            [(UIButton*)sender setImage:img forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)waterMarkVideo:(id)sender {
    if(!imagePicker || !img)
    {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *watermarkedVideoPath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"watermarked-%d.MOV",arc4random() % 1000]];
    
    NSURL *watermarkedVideoUrl = [NSURL fileURLWithPath:watermarkedVideoPath];
    if([[AssetsEditor new] watermarkFile:[NSURL fileURLWithPath:mediaStoragePath] watermarkImg:img withWidth:200 andHeight:100 isLeftTop:YES outputURL:watermarkedVideoUrl])
    {
        mediaStoragePath=[watermarkedVideoUrl path];

        [self loadMoviePlayerWithFilePath:mediaStoragePath inPlayerView:playerView];
    }
}

- (IBAction)loadVideo:(id)sender {
    videoPicker=[MediaPicker new];
    [videoPicker loadAssetFromViewController:self WithAssetType:(NSString *)kUTTypeMovie andUIImagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum andGetDataCompletitionBlock:^(id obj, NSError *err) {
        mediaStoragePath=[(NSURL*)obj path];
        [self loadMoviePlayerWithFilePath:mediaStoragePath inPlayerView:playerView];
    }];
}
- (IBAction)convertVideo:(id)sender {
   if(mediaStoragePath)
   {
       
       AssetsEditor* editor=[AssetsEditor new];
       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths objectAtIndex:0];
       NSString *convertVideoPath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"convert-%d.MOV",arc4random() % 1000]];
       
       NSURL *convertVideoUrl = [NSURL fileURLWithPath:convertVideoPath];
       [GiFHUD showWithOverlay];
       [editor convertMOVVideoToLowQuailtyWithInputURL:[NSURL fileURLWithPath :mediaStoragePath]outputURL:convertVideoUrl andCompletedHandler:^{
           [GiFHUD dismiss];
           mediaStoragePath=convertVideoPath;
           [self loadMoviePlayerWithFilePath:mediaStoragePath inPlayerView:playerView];
       }];

   }
}
- (IBAction)togif:(id)sender {
    [GiFHUD showWithOverlay];
    [NSGIF optimalGIFfromURL:[NSURL fileURLWithPath :mediaStoragePath] loopCount:0 completion:^(NSURL *GifURL) {
        [GiFHUD dismiss];
        gifURL=GifURL;
        NSLog(@"Finished generating GIF: %@", GifURL);
        [[OverlayViewHelper sharedInstance] addwebViewToViewController:self withGifURL:GifURL andFrame:playerView.frame];
    }];
}
- (IBAction)shareGIF:(id)sender {
    if(gifURL)
    {
        [self popShareMenu];
    }
}

- (IBAction)playVideo:(id)sender {
    [player play];
}

- (IBAction)back:(id)sender {
    [Navigator popFromViewController:self withAnimated:YES];
}

- (void)popShareMenu
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 350.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"Share to"];
    [poplistview show];
}

#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    
    int row = indexPath.row;
    switch (row) {
        case 0:
            cell.textLabel.text = @"Youtube";
            cell.imageView.image = [UIImage imageNamed:@"youtube.png"];
            break;
        case 1:
            cell.textLabel.text = @"Instagram";
            cell.imageView.image = [UIImage imageNamed:@"instagram.png"];
            break;
        case 2:
            cell.textLabel.text = @"Facebook";
            cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
            break;
        case 3:
            cell.textLabel.text = @"Twitter";
            cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
            break;
        case 4:
            cell.textLabel.text = @"Camera Roll";
            cell.imageView.image = [UIImage imageNamed:@"cameraroll.png"];
            break;
        case 5:
            cell.textLabel.text = @"Via";
            cell.imageView.image = [UIImage imageNamed:@"btn_explore_active.png"];
            break;
        case 6:
        default:
            break;
            
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    if([Connectivity isNetConnectWithMessageFromViewController:self])
    {
        switch (indexPath.row) {
            case 0:
//                [self shareViaYouTube];
                break;
            case 1:
//                [self shareViaInstagram];
                break;
            case 2:
                [self shareViaFacebook];
                break;
            case 3:
//                [self shareViaTwitter:selectedDive.diveRecordId];
                break;
            case 4:
//                [self saveToCameraRoll];
                [[AssetsEditor new] sendGIFFileToAlbumAtURL:gifURL];
                break;
            case 5:
                [ShareHelper shareFromViewController:self withTextObject:@"" andURLString:@"www.google.com"];
                break;
            case 6:
            default:
//                [self shareViaMore:selectedDive.diveRecordId];
                //[self shareViaMore:@"6031"];//for testing
                break;
        }
    }
    else
    {
    }
}

-(void)shareViaFacebook
{
    [[FBSharedAnimation sharedInstance] startAnimationFromViewController:self withCompletion:^{
    }];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

@end
