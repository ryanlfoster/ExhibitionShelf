//
//  ShelfFirstViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfFirstViewController.h"
#import <QuickLook/QuickLook.h>
#import "Exhibition.h"
#import "ExhibitionStore.h"
#import "Reachability.h"
@interface ShelfFirstViewController ()
-(void)downloadExhibition:(Exhibition *)exhibition updateCover:(FirstCoverView *)cover;
//reachabilityChanged
-(void)reachabilityChanged:(NSNotification *)note;
@end

@implementation ShelfFirstViewController
@synthesize containerView = _containerView;
@synthesize navigationBar = _navigationBar;
@synthesize exhibitionStore = _exhibitionStore;
@synthesize progressHUD = _progressHUD;

@synthesize listData = _listData;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"全景展览";
        self.tabBarItem.image = [UIImage imageNamed:@"nav_exhibition.png"];
        }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSThread
    [NSThread detachNewThreadSelector:@selector(resourceRequest) toTarget:self withObject:nil];
    
    //load progressHUD
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    self.progressHUD.labelText = @"努力加载中";
    [_progressHUD show:YES];
    
    /***************************************load View****************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"background_main.jpg"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    
    /************************************Reachability****************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"http://www.vrdam.com/app/exhibition.plist"];
    [reach startNotifier];
    	
}

- (void)viewDidUnload
{
    [self setContainerView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_top.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

-(void)resourceRequest
{
    //init Store;
    _exhibitionStore = [[ExhibitionStore alloc]init];
    [_exhibitionStore startup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showShelf)
                                                 name:EXHIBITION_CHANGED_STATUS_NOTIFICATION
                                               object:nil];
}

-(void)showShelf {
    if([_exhibitionStore isExhibitionReady]) {
        _containerView.contentSize = CGSizeMake(0, 1900);
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.alpha=1.0;
        
        //back main thread
        [self performSelectorOnMainThread:@selector(updateShelf) withObject:_containerView waitUntilDone:NO];
    } else {
        _containerView.alpha=0.0;
    }

}

-(void)updateShelf {
    
    if(_containerView != nil){
        [_containerView removeFromSuperview];
    }
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 1024, 768)];
    _containerView.contentSize = CGSizeMake(0, 1900);
    _containerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_containerView];

    NSInteger exhibitionCount = [_exhibitionStore numberOfStoreExhibition];
    for(NSInteger i = 0;i < exhibitionCount;i++) {
        Exhibition *anExhibition = [_exhibitionStore exhibitionAtIndex:i];
        FirstCoverView *cover = [[FirstCoverView alloc] initWithFrame:CGRectZero];
        cover.exhibitionID = anExhibition.exhibitionID;
        cover.delegate = self;
        cover.title.text = anExhibition.title;
        cover.cover.image = [UIImage imageWithContentsOfFile:[anExhibition exhibitionImagePath]];
        if([anExhibition isExhibitionAvailibleForRead]) {
            [cover.button setTitle:@"观 看" forState:UIControlStateNormal];
            [cover.button setBackgroundImage:[UIImage imageNamed:@"view_button.png"] forState:UIControlStateNormal];
        } else {
            [cover.button setTitle:@"下 载" forState:UIControlStateNormal];
        }
        NSInteger row = i/2;
        NSInteger col = i%2;
        CGRect coverFrame = cover.frame;
        coverFrame.origin=CGPointMake(col * CGRectGetWidth(coverFrame) , CGRectGetHeight(coverFrame)*row);
        cover.frame=coverFrame;
        [_containerView addSubview:cover];
        
        if(_progressHUD){
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }

    }
     
}

-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reach = [note object];
    if(![reach isReachable])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的连接已中断或当前网络不稳定" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
    }
}

//-(FirstCoverView *)coverWithID:(NSString *)exhibitionID {
//    for(UIView *aView in _containerView.subviews) {
//        if([aView isKindOfClass:[FirstCoverView class]] && [[(FirstCoverView *)aView exhibitionID] isEqualToString:exhibitionID]) {
//            return (FirstCoverView *)aView;
//        }
//    }
//    return nil;
//}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

#pragma mark - ShelfViewControllerProtocol implementation

-(void)coverSelected:(FirstCoverView *)cover {
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"http://www.vrdam.com/app/exhibition.plist"];

    if ([reach startNotifier]) {
        NSString *selectedExhibitionID = cover.exhibitionID;
        Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
        if([selectedExhibition isExhibitionAvailibleForRead]){
            [self openZip:selectedExhibition];
        }
        else if([cover.button.titleLabel.text isEqual: @"取 消"]){
            [self cancelDownloadExhibition:selectedExhibition updateCover:cover];
            cover.progress.alpha=0.0;
            [cover.button setBackgroundImage:[UIImage imageNamed:@"download_button.png"] forState:UIControlStateNormal];
            [cover.button setTitle:@"下 载" forState:UIControlStateNormal];
            cover.button.alpha=1.0;
        }
        else [self downloadExhibition:selectedExhibition updateCover:cover];
    }else{
        return;
    }

}

#pragma mark - Actions
-(void)openZip:(Exhibition *)selectedExhibition{
    
    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
    NSString *documentPath = [[[selectedExhibition contentURL]URLByAppendingPathComponent:@"exhibition"]path];
    NSLog(@"documentPath = %@",documentPath);
    NSBundle *myBundle = [NSBundle bundleWithPath:documentPath];
    NSLog(@"myBundle = %@",myBundle);
    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
    viewController.navigationBarTitle = selectedExhibition.title;
    //turn view
    if(viewController.str != nil){
        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:viewController animated:YES];
    }
}

-(void)downloadExhibition:(Exhibition *)exhibition updateCover:(FirstCoverView *)cover {
    
    cover.progress.alpha=1.0;
    cover.progress.progress = 0;
    [cover.button setBackgroundImage:[UIImage imageNamed:@"cancel_button.png"] forState:UIControlStateNormal];
    cover.button.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14.0];
    [cover.button setTitle:@"取 消" forState:UIControlStateNormal];
    cover.button.alpha=1.0;
    
    [exhibition addObserver:cover forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
    
    [_exhibitionStore scheduleDownloadOfExhibition:exhibition];
}

-(void)cancelDownloadExhibition:(Exhibition *)exhibition updateCover:(FirstCoverView *)cover
{
    [_exhibitionStore clearQueue:exhibition];
}

#pragma mark - NSNotification
-(void)exhibitionDidEndDownload:(NSNotification *)notification {
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
    
}

-(void)exhibitionDidFailDownload:(NSNotification *)notification {
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
}


@end
