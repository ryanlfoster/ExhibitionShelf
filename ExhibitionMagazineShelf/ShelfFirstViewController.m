//
//  ShelfFirstViewController.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-3-20.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "ShelfFirstViewController.h"
#import "ShelfThirdViewController.h"
#import "Exhibition.h"
#import "ExhibitionStore.h"
#import "Reachability.h"
#import "FirstCoverView.h"
#import "CustomPageControl.h"
#import "ExhibitionViewController.h"

NSUInteger numberOfPages;

@interface ShelfFirstViewController ()

@property (strong, nonatomic) ExhibitionStore *exhibitionStore;
@property (strong, nonatomic) PlaySoundTools *sound;
@property (weak, nonatomic) Exhibition *readyForDeleteExhibition;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) NSTimer *timerReadyDownload;
@property (weak, nonatomic) NSTimer *timerPlay;
@property (weak, nonatomic) NSTimer *timerProgressHUD;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) CGPoint point;

-(void)concealProgressHUD;
-(void)resourceRequest;
-(void)showShelf;
-(void)updateShelf;
-(void)exhibitionDidEndDownload:(NSNotification *)notification;
-(void)exhibitionDidFailDownload:(NSNotification *)notification;
-(void)slide;

@end

@implementation ShelfFirstViewController
@synthesize containerView = _containerView;
@synthesize pageControl = _pageControl;
@synthesize exhibitionStore = _exhibitionStore;
@synthesize progressHUD = _progressHUD;
@synthesize sound = _sound;
@synthesize timerReadyDownload = _timerReadyDownload;
@synthesize timerPlay = _timerPlay;
@synthesize timerProgressHUD = _timerProgressHUD;
@synthesize readyForDeleteExhibition = _readyForDeleteExhibition;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize point = _point;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _leftButton.alpha = 0.0f;
    _rightButton.alpha = 0.0f;

    /***********************************background***************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"exhibitiondisplay_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    
    /***********************************MBProgressHUD************************************/
    //load progressHUD
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    self.progressHUD.labelText = @"loading...";
    self.progressHUD.alpha = 0.5f;
    [_progressHUD show:YES];
    
    /******************************Register NSNotificationCenter*************************/
    //register a notificaiton to control show shelf
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showShelf)
                                                 name:EXHIBITION_CHANGED_STATUS_NOTIFICATION
                                               object:_exhibitionStore];
    
    /******************************detach new thread*************************/
    //new NSThread
    [NSThread detachNewThreadSelector:@selector(resourceRequest) toTarget:self withObject:nil];
    
    /***********************************Register NSTimer********************************/
    //timer progressHUD
    _timerProgressHUD = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(concealProgressHUD) userInfo:nil repeats:NO];

}

- (void)viewDidUnload
{
    [self setContainerView:nil];
    [self setPageControl:nil];
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

#pragma mark -Private Methods implementation
/**
 *	detach new thread to init exhibition store
 */
-(void)resourceRequest
{
    _exhibitionStore = [[ExhibitionStore alloc]init];
    [_exhibitionStore startup];
}

/**
 *	conceal progressHUD
 */
-(void)concealProgressHUD
{
    if(_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Ooops!The network connection was slowly..." delegate:nil cancelButtonTitle:@"I Know" otherButtonTitles:nil];
        [alerView show];
    }
}

/**
 *	get number of page ready for view scrollView
 */
-(void)showShelf {
    if([_exhibitionStore isExhibitionStoreReady]) {
        
        if(_timerProgressHUD != nil){
            [_timerProgressHUD invalidate];
            _timerProgressHUD = nil;
        }
        
        if([_exhibitionStore numberOfStoreExhibition] % 6 == 0){
            numberOfPages = [_exhibitionStore numberOfStoreExhibition] / 6;
        }else{
            numberOfPages = 1 + [_exhibitionStore numberOfStoreExhibition] / 6;
        }
        NSLog(@"numberOfPages == %d",numberOfPages);
        
        if(numberOfPages > 6){
            _rightButton.alpha = 1.0f;
        }
        
        //back main thread
        [self performSelectorOnMainThread:@selector(updateShelf) withObject:_containerView waitUntilDone:NO];
        
    }else return;
}

/**
 *	show exhibition shelf
 */
-(void)updateShelf
{
    if(_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    //scroll view
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 266 * 2 + 36)];
    _containerView.pagingEnabled = YES;
    _containerView.contentSize = CGSizeMake(_containerView.frame.size.width * numberOfPages, 0);
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];
    
    //page view
    _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"image_page_state_normal.png"]];
    [_pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"image_page_state_highly.png"]];
    _pageControl.numberOfPages = numberOfPages;
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = NO;
    [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_pageControl];
    
    NSInteger exhibitionCount = [_exhibitionStore numberOfStoreExhibition];
    for(NSInteger i = 0;i < exhibitionCount;i++) {
        
        Exhibition *anExhibition = [_exhibitionStore exhibitionAtIndex:i];
        FirstCoverView *cover = [[FirstCoverView alloc] initWithFrame:CGRectZero];
        cover.exhibitionID = anExhibition.exhibitionID;
        cover.coverImageView.exhibitionID = anExhibition.exhibitionID;
        cover.coverImageView.imgURL = anExhibition.coverURL;
        cover.downloadImageView.description.text = anExhibition.description;
        cover.briefUILable.titleLabel.text = anExhibition.title;
        cover.briefUILable.subTitleLabel.text = anExhibition.subTitle;
        cover.briefUILable.dateLabel.text = anExhibition.date;
        cover.changeLocationBriefUILable.titleLabel.text = anExhibition.title;
        cover.changeLocationBriefUILable.subTitleLabel.text = anExhibition.subTitle;
        cover.changeLocationBriefUILable.dateLabel.text = anExhibition.date;
        
        cover.delegate = self;
        cover.delegateDownload = self;
        cover.delegateCancelDownload = self;
        cover.delegatePlay = self;
        
//        CGFloat edge;
//        if(i >= 6 ){
//            edge = 70.0f;
//        }else edge = 0;
//        CGFloat row = i / 2;
//        CGFloat col = i % 2;
//        CGRect coverFrame = cover.frame;
//        coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * row + 96.0f * row + edge * (i / 6), CGRectGetHeight(coverFrame) * col + col * 36.0f);   
//        cover.frame = coverFrame;
//        cover.backgroundColor = [UIColor clearColor];
//        [_containerView addSubview:cover];
        
        CGFloat edge;
        CGFloat row = i % 3;
        CGFloat col = 0.0;
        
        if (((i / 3) % 2) == 1) {
            col = 1;
        }else col = 0;
        
        if(i >= 6 ){
            edge = 1024.0f;
        }else edge = 0;
        
        CGRect coverFrame = cover.frame;
        coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * row + 96.0f * row + edge * (i / 6), CGRectGetHeight(coverFrame) * col + col * 36.0f);
        cover.frame = coverFrame;
        cover.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:cover];
    }
    
    UITapGestureRecognizer *clickGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slide)];
    clickGestureRecognizer.delegate = self;
    [_containerView addGestureRecognizer:clickGestureRecognizer];
}

/**
 *	left slide & right slide
 */
-(void)slide
{
    NSLog(@"slide !!!");
    int x = _point.x;
    int y = _point.y;
    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    
    CGFloat pageWidth = _containerView.frame.size.width;
    int page = floor((_containerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(CGRectContainsPoint(CGRectMake(page * 1024, 220, 100, 100), _point)){
        NSLog(@"turn left");
        if(_leftButton.alpha == 1.0f){
            [_containerView setContentOffset:CGPointMake(1024.0f * (page - 1), 0.0f) animated:YES];
        }
        
    }else if (CGRectContainsPoint(CGRectMake(page * 1024 + 950, 220, 100, 100),_point)){
        NSLog(@"turn right");
        if(_rightButton.alpha == 1.0f){
            [_containerView setContentOffset:CGPointMake(1024.0f * (page + 1), 0.0f) animated:YES];
        }
    }
}

#pragma mark -ShelfViewControllerClickProtocol implementation
/**
 *	click exhibition with coverImageView
 *
 *	@param	cover	FirstCoverView
 */
-(void)clickExhibition:(FirstCoverView *)cover
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"pop" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
    
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    if([selectedExhibition isExhibitionAvailibleForPlay]){
        cover.playImageView.alpha = 1.0f;
        [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(concealPlayCoverImageViewNotification:) name:CONCEAL_PLAYCOVERIMAGEVIEW_NOTIFICATION object:selectedExhibition];
        
        //create a timer count :8s later [selectedExhibition concealPlayCoverImageViewNotification]
        _timerPlay = [NSTimer scheduledTimerWithTimeInterval:8.0 target:selectedExhibition selector:@selector(sendConcealPlayCoverImageViewNotification) userInfo:nil repeats:NO];
    }else{
        cover.downloadImageView.alpha = 1.0f;
        [cover.briefUILable changeGreen];
        [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(concealDownloadCoverImageViewNotification:) name:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:selectedExhibition];
        
        //create a timer count :8s later [selectedExhibition sendConcealDownloadCoverImageViewNotification]
        _timerReadyDownload = [NSTimer scheduledTimerWithTimeInterval:8.0 target:selectedExhibition selector:@selector(sendConcealDownloadCoverImageViewNotification) userInfo:nil repeats:NO];
    }
    
}

#pragma mark -ShelfViewControllerClickDownloadExhibitionProtocol implementation
/**
 *	click exhibition with cover DownloadImageView
 *
 *	@param	cover	FirstCoverView
 */
-(void)clickDownloadExhibition:(FirstCoverView *)cover
{
    if([Exhibition isDownlaoding]){
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在下载请稍后" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"alert" ofType: @"wav"];
        _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
        [_sound play];
        return;
    }
    
    NSLog(@"Begin download !!!");
    
    //stop timer
    [_timerReadyDownload invalidate];
    
    //SqlService Insert exhibition to sql
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:cover.exhibitionID];
    [NSTimer cancelPreviousPerformRequestsWithTarget:selectedExhibition];
    
    cover.downloadImageView.alpha = 0.0f;
    cover.downloadingImageView.alpha = 1.0f;
    
    cover.briefUILable.alpha = 0.0f;
    cover.changeLocationBriefUILable.alpha = 1.0f;
    [cover.changeLocationBriefUILable changeGreen];
    
    cover.progressBar.alpha = 1.0f;
    cover.progressBar.progress = 0.0f;
    
    [selectedExhibition addObserver:cover forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    
    [self download:selectedExhibition];

}

/**
 *	download exhibition
 *
 *	@param	selectedExhibition	click target exhibition
 */
-(void)download:(Exhibition *)selectedExhibition
{
    NSString *downloadString = selectedExhibition.downloadURL;
    NSLog(@"downloadString = %@",downloadString);
    if(!downloadString)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadString]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:selectedExhibition];
    [conn start];
}

#pragma mark -ShelfViewControllerClickCancelDownloadExhibitionProtocol implementation
/**
 *	click exhibition with downloadingImageView
 *
 *	@param	cover	FirstCoverView
 */
-(void)clickCancelDownloadExhibition:(FirstCoverView *)cover
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"alert" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
    
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真的要取消下载么？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回", nil];
    [alert show];
    _readyForDeleteExhibition = selectedExhibition;
}

#pragma mark -UIAlertViewDelegate
/**
 *	alert view which whether cancel download
 *
 *	@param	alertView	alerView
 *	@param	buttonIndex	0 : YES 1:return
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [NSThread sleepForTimeInterval:1];
        [_readyForDeleteExhibition sendFailedDownloadNotification];
        [_readyForDeleteExhibition stopDownload];
    }else return;
    
}

#pragma mark -ShelfViewControllerClickCancelDownloadExhibitionProtocol implementation
/**
 *	click exhibition which has downloaded
 *
 *	@param	cover	FirstCoverView
 */
-(void)clickPlayExhibition:(FirstCoverView *)cover
{
    
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:cover.exhibitionID];
    ExhibitionViewController *evc = [[ExhibitionViewController alloc] init];
    NSString *documentPath = [[[selectedExhibition contentURL]URLByAppendingPathComponent:@"exhibition"]path];
    NSBundle *myBundle = [NSBundle bundleWithPath:documentPath];
    evc.str = [myBundle pathForResource:@"index" ofType:@"html"];
    evc.navigationBarTitle = selectedExhibition.title;
    //turn view
    if(evc.str != nil){
        [evc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:evc animated:YES];
    }
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"applaunch" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
}

#pragma mark -UIScrollViewDelegate
/**
 *	scrollView delegate
 *
 *	@param	scrollView	crollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _containerView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    NSArray *subView = _pageControl.subviews;
    for(int i = 0; i < [subView count]; i++){
        UIImageView *dot = [subView objectAtIndex:i];
        dot.image = (_pageControl.currentPage == i ? [UIImage imageNamed:@"image_page_state_highly.png"] : [UIImage imageNamed:@"image_page_state_normal.png"]);
    }
    
    if (_pageControl.currentPage == 0) {
        _leftButton.alpha = 0.0f;
    }else if(_pageControl.currentPage == [subView count] - 1){
        _rightButton.alpha = 0.0f;
    }else{
        _leftButton.alpha = 1.0f;
        _rightButton.alpha = 1.0f;
    }
}

#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if([view isKindOfClass:[UIScrollView class]]){
        _point = [touch locationInView:[touch view]];
        return YES;
    }
    return NO;
}

#pragma mark -MBProgressHUDDelegate methods
/**
 *	progressHUD remove
 *
 *	@param	hud	self.progressHUD
 */
- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

#pragma mark -KVO methods
/**
 *	exhibition download have finished
 *
 *	@param	notification	exhibition
 */
-(void)exhibitionDidEndDownload:(NSNotification *)notification
{    
    Exhibition *exhibition = (Exhibition *)notification;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
}
/**
 *	exhibition download have failed
 *
 *	@param	notification	exhibition
 */
-(void)exhibitionDidFailDownload:(NSNotification *)notification
{
    Exhibition *exhibition = (Exhibition *)notification;    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];    
}

@end
