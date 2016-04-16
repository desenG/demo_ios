//
//  PreviewViewController.h
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "MediaPicker.h"
#import "AssetsEditor.h"
#import "ProfileHelper.h"
#import "NSGIF.h"
#import "OverlayViewHelper.h"
#import "GiFHUD.h"
#import "UIPopoverListView.h"
#import "ShareHelper.h"
#import "FBSharedAnimation.h"

@interface PreviewViewController : UIViewController<VIMVideoPlayerViewDelegate>
@property(nonatomic,retain) NSString *mediaStoragePath;
@property(nonatomic,strong) VIMVideoPlayerView *moviePlayerController;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayback;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@end
