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
@synthesize briefUILable = _briefUILable;

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
        _downloadImageView.alpha = 0.0f;
        _downloadImageView.userInteractionEnabled = YES;
        [_downloadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDownloadExhibition:)]];
        
        _briefUILable = [[BriefUILabel alloc] initWithFrame:CGRectMake(85, 212, 220, 52)];
        
        [self addSubview:_coverImageViewFrameView];
        [self addSubview:_coverImageView];
        [self addSubview:_downloadImageView];
        [self addSubview:_briefUILable];
        
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

#pragma mark - ShelfViewControllerClickCancelDownloadExhibitionProtocol
/**********************************************************
 函数名称：-(void)clickCancelDownloadExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)clickDownloadExhibition:(id)sender
{
    [_delegateCancelDownload clickDownloadExhibition:self];
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
    //observer & sender to remove from the dispatch table
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:exhibition];
}

@end
