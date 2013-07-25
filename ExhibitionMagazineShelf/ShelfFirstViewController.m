//
//  ShelfFirstViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
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

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) NSTimer *timer;

@end
@implementation ShelfFirstViewController
@synthesize containerView = _containerView;
@synthesize pageControl = _pageControl;
@synthesize exhibitionStore = _exhibitionStore;
@synthesize progressHUD = _progressHUD;
@synthesize timer = _timer;

#pragma mark -nib init
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/***********************************background****************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"exhibitiondisplay_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
/************************************************************************************/
    
    //load progressHUD
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    self.progressHUD.labelText = @"努力加载中";
    [_progressHUD show:YES];
    
    //register a notificaiton to control show shelf
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showShelf)
                                                 name:EXHIBITION_CHANGED_STATUS_NOTIFICATION
                                               object:_exhibitionStore];
    
    //new NSThread
    [NSThread detachNewThreadSelector:@selector(resourceRequest) toTarget:self withObject:nil];

}

- (void)viewDidUnload
{
    [self setContainerView:nil];
    [self setPageControl:nil];
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
/**********************************************************
 函数名称：-(void)resourceRequest
 函数描述：开启新线程，去初始化数据
 输入参数：N/A
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)resourceRequest
{
    //init Store
    _exhibitionStore = [[ExhibitionStore alloc]init];
    [_exhibitionStore startup];
}
/**********************************************************
 函数名称：-(void)showShelf
 函数描述：显示scrollView
 输入参数：N/A
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)showShelf {
    if([_exhibitionStore isExhibitionStoreReady]) {
        
        if([_exhibitionStore numberOfStoreExhibition] % 6 == 0){
            numberOfPages = [_exhibitionStore numberOfStoreExhibition] / 6;
        }else{
            numberOfPages = 1 + [_exhibitionStore numberOfStoreExhibition] / 6;
        }
        NSLog(@"numberOfPages == %d",numberOfPages);
        
        //back main thread
        [self performSelectorOnMainThread:@selector(updateShelf) withObject:_containerView waitUntilDone:NO];
        
    }else return;
}
/**********************************************************
 函数名称：-(void)updateShelf
 函数描述：更新书内容
 输入参数：N/A
 输出参数：N/A
 返回值：void
 **********************************************************/
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
    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"imagePageStateNormal.png"]];
    [_pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"imagePageStateHighly.png"]];
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
        
        cover.delegate = self;
        cover.delegateDownload = self;
        cover.delegateCancelDownload = self;
        cover.delegatePlay = self;
        
        CGFloat edge;
        if(i >= 6 ){
            edge = 70.0f;
        }else edge = 0;
        CGFloat row = i / 2;
        CGFloat col = i % 2;
        CGRect coverFrame = cover.frame;
        coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * row + 96.0f * row + edge * (i / 6), CGRectGetHeight(coverFrame) * col + col * 36.0f);   
        cover.frame = coverFrame;
        cover.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:cover];
    }
}


#pragma mark -ShelfViewControllerClickProtocol implementation
/**********************************************************
 函数名称：-(void)coverSelected:(FirstCoverView *)cover
 函数描述：ShelfViewControllerProtocol
 输入参数：(FirstCoverView *)cover：view
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)clickExhibition:(FirstCoverView *)cover
{
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    if([selectedExhibition isExhibitionAvailibleForPlay]){
        cover.playImageView.alpha = 1.0f;
        [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(concealPlayCoverImageViewNotification:) name:CONCEAL_PLAYCOVERIMAGEVIEW_NOTIFICATION object:selectedExhibition];
        
        //create a timer count :8s later [selectedExhibition concealPlayCoverImageViewNotification]
        _timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:selectedExhibition selector:@selector(sendConcealPlayCoverImageViewNotification) userInfo:nil repeats:NO];
    }else{
        cover.downloadImageView.alpha = 1.0f;
        [cover.briefUILable changeGreen];
        [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(concealDownloadCoverImageViewNotification:) name:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:selectedExhibition];
        
        //create a timer count :8s later [selectedExhibition sendConcealDownloadCoverImageViewNotification]
        _timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:selectedExhibition selector:@selector(sendConcealDownloadCoverImageViewNotification) userInfo:nil repeats:NO];
    }
    
}

#pragma mark -ShelfViewControllerClickDownloadExhibitionProtocol implementation
-(void)clickDownloadExhibition:(FirstCoverView *)cover
{
    NSLog(@"Begin download !!!");
    
    //stop timer
    [_timer invalidate];
    
    //SqlService Insert exhibition to sql
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:cover.exhibitionID];
    [NSTimer cancelPreviousPerformRequestsWithTarget:selectedExhibition];
    
    cover.downloadImageView.alpha = 0.0f;
    [cover.briefUILable changeNormal];
    cover.downloadingImageView.alpha = 1.0f;
    cover.progressBar.alpha = 1.0;
    cover.progressBar.progress = 0;
    
    [selectedExhibition addObserver:cover forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidEndDownload:) name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exhibitionDidFailDownload:) name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:selectedExhibition];
    
    NSString *downloadString = selectedExhibition.downloadURL;
    NSLog(@"downloadString = %@",downloadString);
    if(!downloadString)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadString]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:selectedExhibition];
    [conn start];
}

#pragma mark -ShelfViewControllerClickCancelDownloadExhibitionProtocol implementation
/**********************************************************
 函数名称：-(void)clickCancelDownloadExhibition:(FirstCoverView *)cover
 函数描述：
 输入参数：
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)clickCancelDownloadExhibition:(FirstCoverView *)cover
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在下载，请等待..." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alerView show];
}

#pragma mark -ShelfViewControllerClickCancelDownloadExhibitionProtocol implementation
/**********************************************************
 函数名称：-(void)clickPlayExhibition:(FirstCoverView *)cover
 函数描述：
 输入参数：
 输出参数：N/A
 返回值：void
 **********************************************************/
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
}


#pragma mark -UIScrollView degelete
/**********************************************************
 函数名称：-(void)scrollViewDidScroll:(UIScrollView *)scrollView
 函数描述：UIScrollView degelete
 输入参数：(UIScrollView *)scrollView
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _containerView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    NSArray *subView = _pageControl.subviews;
    for(int i = 0; i < [subView count]; i++){
        UIImageView *dot = [subView objectAtIndex:i];
        dot.image = (_pageControl.currentPage == i ? [UIImage imageNamed:@"imagePageStateHighly.png"] : [UIImage imageNamed:@"imagePageStateNormal.png"]);
    }
}

#pragma mark -MBProgressHUDDelegate methods
/**********************************************************
 函数名称：- (void)hudWasHidden:(MBProgressHUD *)hud
 函数描述：隐藏_progressHUD
 输入参数：(MBProgressHUD *)hud：view
 输出参数：N/A
 返回值：void
 **********************************************************/
- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

#pragma mark -KVO methods
/**********************************************************
 函数名称：-(void)exhibitionDidEndDownload:(NSNotification *)notification
 函数描述：
 输入参数：(NSNotification *)notification
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)exhibitionDidEndDownload:(NSNotification *)notification
{
    Exhibition *exhibition = (Exhibition *)notification;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
}
/**********************************************************
 函数名称：-(void)exhibitionDidFailDownload:(NSNotification *)notification
 函数描述：
 输入参数：(NSNotification *)notification
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)exhibitionDidFailDownload:(NSNotification *)notification
{
    Exhibition *exhibition = (Exhibition *)notification;    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];    
}

@end
