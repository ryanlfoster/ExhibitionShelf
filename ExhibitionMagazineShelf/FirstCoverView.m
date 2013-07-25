//
//  FirstCoverView.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-3.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "FirstCoverView.h"
#import "Exhibition.h"
@implementation FirstCoverView
@synthesize exhibitionID = _exhibitionID;
@synthesize coverImageViewFrameView = _coverImageViewFrameView;
@synthesize coverImageView = _coverImageView;
@synthesize downloadImageView = _downloadImageView;
@synthesize downloadingImageView = _downloadingImageView;
@synthesize playImageView = _playImageView;
@synthesize briefUILable = _briefUILable;
@synthesize progressBar = _progressBar;

#pragma mark -init
/**********************************************************
 函数名称：- (id)initWithFrame:(CGRect)frame
 函数描述：初始化view
 输入参数：(CGRect)frame ：view 框架
 输出参数：n/a
 返回值：void
 **********************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(85, 0, 222, 266);
        
        _coverImageViewFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _coverImageViewFrameView.image = [UIImage imageNamed:@"imagelayout.png"];
        
        _coverImageView = [[CoverImageView alloc] initWithFrame:CGRectMake(85 + 4, 0 + 4, 212, 194)];
        _coverImageView.userInteractionEnabled = YES;
        [_coverImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickExhibition:)]];
        
        _downloadImageView = [[DownloadImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _downloadImageView.image = [UIImage imageNamed:@"imageview_ready_download.png"];
        _downloadImageView.alpha = 0.0f;
        _downloadImageView.userInteractionEnabled = YES;
        [_downloadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDownloadExhibition:)]];
        
        _downloadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _downloadingImageView.image = [UIImage imageNamed:@"imageview_downloading.png"];
        _downloadingImageView.alpha = 0.0f;
        _downloadingImageView.userInteractionEnabled = YES;
        [_downloadingImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancelDownloadExhibition:)]];
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _playImageView.image = [UIImage imageNamed:@"playImageView.png"];
        _playImageView.alpha = 0.0f;
        _playImageView.userInteractionEnabled = YES;
        [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPlayExhibition:)]];
        
        _progressBar = [[MCProgressBar alloc] initWithFrame:CGRectMake(85 + 10, 0 + 4 + 186, 200, 6) backgroundImage:[UIImage imageNamed:@"progressbar_background.png"] foregroundImage:[UIImage imageNamed:@"progressbar_foreground.png"]];
        _progressBar.alpha = 0.0f;
        
        _briefUILable = [[BriefUILabel alloc] initWithFrame:CGRectMake(85, 212, 220, 52)];
        
        [self addSubview:_coverImageViewFrameView];
        [self addSubview:_coverImageView];
        [self addSubview:_downloadImageView];
        [self addSubview:_downloadingImageView];
        [self addSubview:_playImageView];
        [self addSubview:_briefUILable];
        [self addSubview:_progressBar];
        
    }
    return self;
}

#pragma mark - ShelfViewControllerClickProtocol
/**********************************************************
 函数名称：-(void)clickExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)clickExhibition:(id)sender
{
    [_delegate clickExhibition:self];
}

#pragma mark - ShelfViewControllerClickDownloadExhibitionProtocol
/**********************************************************
 函数名称：-(void)clickCancelDownloadExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)clickDownloadExhibition:(id)sender
{
    [_delegateDownload clickDownloadExhibition:self];
}

#pragma mark - ShelfViewControllerClickCancelDownloadExhibitionProtocol
/**********************************************************
 函数名称：-(void)clickCancelDownloadExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)clickCancelDownloadExhibition:(id)sender
{
    [_delegateCancelDownload clickCancelDownloadExhibition:self];
}

#pragma mark - ShelfFirstViewControllerClickPlayExhibitionProtocol
/**********************************************************
 函数名称：-(void)clickPlayExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)clickPlayExhibition:(id)sender
{
    [_delegatePlay clickPlayExhibition:self];
}

#pragma mark - KVO and Notifications
/**********************************************************
 函数名称：-(void)cancelDownloadExhibiton:(NSNotification *)notification
 函数描述：conceal _downloadImageView
 输入参数：(NSNotification *)notification
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)concealDownloadCoverImageViewNotification:(NSNotification *)notification
{
    _downloadImageView.alpha = 0.0f;
    [_briefUILable changeNormal];
    //observer & sender to remove from the dispatch table
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:exhibition];
}
-(void)concealPlayCoverImageViewNotification:(NSNotification *)notification
{
    _playImageView.alpha = 0.0f;
    //observer & sender to remove from the dispatch table
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONCEAL_PLAYCOVERIMAGEVIEW_NOTIFICATION object:exhibition];
}
/**********************************************************
 函数名称：-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
 函数描述：Given that the receiver has been registered as an observer of the value at a key path relative to an object, be notified of
 a change to that value.
 输入参数：(NSString *)keyPath : NSKeyValueChangeKindKey entry whose value is an NSNumber wrapping an NSKeyValueChange
 ofObject:(id)object : NSNumber
 change:(NSDictionary *)change: NSKeyValueChange
 context:(void *)context:is always the same pointer that was passed in at observer registration time.
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    _progressBar.progress = value;
}
/**********************************************************
 函数名称：-(void)exhibitionDidEndDownload:(NSNotification *)notification
 函数描述：下载完成发送通知
 输入参数：(NSNotification *)notification
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)exhibitionDidEndDownload:(NSNotification *)notification
{
    id obj = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:obj];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:obj];
    [obj removeObserver:self forKeyPath:@"downloadProgress"];

    _progressBar.alpha = 0.0f;
    _downloadingImageView.alpha = 0.0f;
    
    if(!transitionLayer){
        transitionLayer = [[CALayer alloc] init];
    }
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)self.coverImageView.image.CGImage;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:self.coverImageView.bounds fromView:self.coverImageView];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:transitionLayer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 1024 / 2)];
    
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
/**********************************************************
 函数名称：-(void)exhibitionDidEndDownload:(NSNotification *)notification
 函数描述：下载失败发送通知
 输入参数：(NSNotification *)notification
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)exhibitionDidFailDownload:(NSNotification *)notification
{
    id obj = [notification object];
    _progressBar.alpha = 0.0f;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:obj];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:obj];
    [obj removeObserver:self forKeyPath:@"downloadProgress"];
}


@end
