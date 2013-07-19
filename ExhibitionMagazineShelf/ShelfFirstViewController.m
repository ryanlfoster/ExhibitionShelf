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
#import <QuartzCore/QuartzCore.h>

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
@synthesize stvc = _stvc;
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
        cover.downloadImageView.image = [UIImage imageNamed:@"imageDownloadView.png"];
        cover.downloadImageView.description.text = anExhibition.description;
        cover.briefUILable.titleLabel.text = anExhibition.title;
        cover.briefUILable.subTitleLabel.text = anExhibition.subTitle;
        cover.briefUILable.dateLabel.text = anExhibition.date;
        
        cover.delegate = self;
        cover.delegateDownload = self;
        cover.delegateCancelDownload = self;
        
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
-(void)clickExhibition:(FirstCoverView *)cover{
    
    cover.downloadImageView.alpha = 1.0f;
    [cover.briefUILable changeGreen];
    
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(concealDownloadCoverImageViewNotification:) name:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:selectedExhibition];
    
    if(_stvc == nil){
        _stvc = [[ShelfThirdViewController alloc] init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:_stvc selector:@selector(addExhibition:) name:ADD_EXHIBITION_NOTIFICATION object:selectedExhibition];
    
    //create a timer count :8s later [selectedExhibition sendConcealDownloadCoverImageViewNotification]
    _timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:selectedExhibition selector:@selector(sendConcealDownloadCoverImageViewNotification) userInfo:nil repeats:NO];
    
}

#pragma mark -ShelfViewControllerClickDownloadExhibitionProtocol implementation
-(void)clickDownloadExhibition:(FirstCoverView *)cover
{
    NSLog(@"Begin download !!!");
    
    cover.downloadImageView.alpha = 0.0f;
    [cover.briefUILable changeNormal];
    cover.downloadingImageView.alpha = 1.0f;
    
    //stop timer
    [_timer invalidate];
    
    //SqlService Insert exhibition to sql
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:cover.exhibitionID];
    [NSTimer cancelPreviousPerformRequestsWithTarget:selectedExhibition];
    
    SqliteService *sqlService = [[SqliteService alloc] init];
    [sqlService insertToDB:selectedExhibition];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:selectedExhibition.coverURL]];
    if(imgData) {
        //save img to sand box 
        [imgData writeToFile:[selectedExhibition exhibitionImagePath] atomically:YES];
    }
 
    [selectedExhibition sendAddExhbitionNotification];
    
    if(!transitionLayer){
        transitionLayer = [[CALayer alloc] init];
    }
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)cover.coverImageView.image.CGImage;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:cover.coverImageView.bounds fromView:cover.coverImageView];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:transitionLayer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.view.bounds.size.width / 2.0)];
    
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:transitionLayer.bounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.5];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime() + 0.25;
    group.duration = 0.8;
    group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation, nil];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [transitionLayer addAnimation:group forKey:@"move"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[transitionLayer animationForKey:@"move"]]) {
		[transitionLayer removeFromSuperlayer];
		[transitionLayer removeAllAnimations];
	}
}

#pragma mark -ShelfViewControllerClickCancelDownloadExhibitionProtocol implementation
-(void)clickCancelDownloadExhibition:(FirstCoverView *)cover
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在下载" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alerView show];
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

//#pragma mark -UIAlertViewDelegate
/**********************************************************
 函数名称：-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 函数描述：UIAlertViewDelegate
 输入参数：(UIAlertView *)alertView:alertView clickedButtonAtIndex:(NSInteger)buttonIndex:button
 输出参数：N/A
 返回值：void
 **********************************************************/
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 0){
//        [NSThread sleepForTimeInterval:1];
//        [receiveExhibition sendFailedDownloadNotification];
//        [receiveExhibition clearOperation];
//    }else return;
//    
//}

//#pragma mark -Actions
/**********************************************************
 函数名称：-(void)cancelDownloadExhibition:(Exhibition *)exhibition updateCover:(FirstCoverView *)cover
 函数描述：取消下载
 输入参数：(Exhibition *)exhibition:某一实例 updateCover:(FirstCoverView *)cover：某一view
 输出参数：exhibition:取消下载某一个实例
 返回值：void
 **********************************************************/
//-(void)cancelDownloadExhibition:(Exhibition *)exhibition updateCover:(FirstCoverView *)cover
//{
//    [exhibition clearOperation];
//}
/**********************************************************
 函数名称：-(void)openZip:(Exhibition *)selectedExhibition
 函数描述：打开压缩文件中的内容 并传递str参数
 输入参数：(Exhibition *)selectedExhibition：某实例
 输出参数：(NSString *)str ：打开的文件名称
 返回值：void
 **********************************************************/
//-(void)openZip:(Exhibition *)selectedExhibition{
//    
//    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
//    NSString *documentPath = [[[selectedExhibition contentURL]URLByAppendingPathComponent:@"exhibition"]path];
//    NSLog(@"documentPath = %@",documentPath);
//    NSBundle *myBundle = [NSBundle bundleWithPath:documentPath];
//    NSLog(@"myBundle = %@",myBundle);
//    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
//    viewController.navigationBarTitle = selectedExhibition.title;
//    //turn view
//    if(viewController.str != nil){
//        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        [self presentModalViewController:viewController animated:YES];
//    }
//}

@end
