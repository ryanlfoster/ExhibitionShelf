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
//@synthesize exhibitionID = _exhibitionID;
//@synthesize cover = _cover;
//@synthesize button = _button;
//@synthesize title = _title;
//@synthesize description = _description;
//@synthesize progressBar = _progressBar;
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
        // frame
//        self.frame = CGRectMake(0, 0, 512, 192);
//        // title label
//        _title = [[UILabel alloc] initWithFrame:CGRectMake(272, 40, 224, 40)];
//        _title.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15.0];
//        _title.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
//        _title.textAlignment = UITextAlignmentLeft;
//        _title.lineBreakMode = UILineBreakModeTailTruncation;
//        _title.numberOfLines = 2;
//        _title.backgroundColor = [UIColor clearColor];
//        _title.shadowColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
//        _title.shadowOffset = CGSizeMake(0.1, 0.1);
//        //description label
//        _description = [[UILabel alloc] initWithFrame:CGRectMake(272, 80, 224, 76)];
//        _description.font = [UIFont fontWithName:@"MicrosoftYaHei" size:12.0];
//        _description.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0f];
//        _description.backgroundColor = [UIColor clearColor];
//        _description.textAlignment = UITextAlignmentLeft;
//        _description.lineBreakMode = UILineBreakModeTailTruncation;
//        _description.numberOfLines = 4;
//        //imageView
//        _cover = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 202, 169)];
//        _cover.userInteractionEnabled = YES;
//        [_cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonCallback:)]];
//        // button
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_button setBackgroundImage:[UIImage imageNamed:@"download_button.png"] forState:UIControlStateNormal];
//        [_button addTarget:self action:@selector(buttonCallback:) forControlEvents:UIControlEventTouchUpInside];
//        _button.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14.0];
//        [_button setTitle:@"下 载" forState:UIControlStateNormal];
//        _button.frame=CGRectMake(272, 166, 76, 26);
//        // progress
//        UIImage *backgroundImage = [UIImage imageNamed:@"progressBar_background_before.png"];
//        UIImage *foregroundImage = [UIImage imageNamed:@"processBar_before.png"];
//        _progressBar = [[MCProgressBar alloc] initWithFrame:CGRectMake(41, 184, 200, 8) backgroundImage:backgroundImage foregroundImage:foregroundImage];
//        _progressBar.alpha=0.0;
//        
//        [self addSubview:_title];
//        [self addSubview:_description];
//        [self addSubview:_cover];
//        [self addSubview:_button];
//        [self addSubview:_progressBar];
        
//        @synthesize coverImageViewFrameView = _coverImageViewFrameView;
//        @synthesize coverImageView = _coverImageView;
//        @synthesize downloadImageView = _downloadImageView;
//        @synthesize titleLabel = _titleLabel;
//        @synthesize subTitleLabel = _subTitleLabel;
//        @synthesize dateLabel = _dateLabel;
        
        self.frame = CGRectMake(0, 0, 341, 300);
        
        _coverImageViewFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 50, 220, 202)];
        _coverImageViewFrameView.image = [UIImage imageNamed:@"imagelayout.png"];
        
        _coverImageView = [[CoverImageView alloc] initWithFrame:CGRectMake(85 + 4, 50 + 4, 212, 194)];
        _coverImageView.userInteractionEnabled = YES;
        
        _downloadImageView = [[DownloadImageView alloc] initWithFrame:CGRectMake(85, 50, 220, 202)];
        
        _briefUILable = [[BriefUILabel alloc] initWithFrame:CGRectMake(85, 260, 220, 50)];
        
        [self addSubview:_coverImageViewFrameView];
        [self addSubview:_coverImageView];
        [self addSubview:_downloadImageView];
        [self addSubview:_briefUILable];
        
    }
    return self;
}

#pragma mark - ShelfViewControllerProtocol
/**********************************************************
 函数名称：-(void)buttonCallback:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
//-(void)buttonCallback:(id)sender
//{
//    [_delegate coverSelected:self];
//}

#pragma mark - KVO and Notifications
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
    
//    float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
//    _progressBar.progress = value;
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
//    id obj = [notification object];
//    _progressBar.alpha=0.0;
//    [_button setBackgroundImage:[UIImage imageNamed:@"view_button.png"] forState:UIControlStateNormal];
//    [_button setTitle:@"观 看" forState:UIControlStateNormal];
//    _button.alpha=1.0;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:obj];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:obj];
//    [obj removeObserver:self forKeyPath:@"downloadProgress"];
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
//    id obj = [notification object];
//    _progressBar.alpha=0.0;
//    [_button setBackgroundImage:[UIImage imageNamed:@"download_button.png"] forState:UIControlStateNormal];
//    [_button setTitle:@"下 载" forState:UIControlStateNormal];
//    _button.alpha=1.0;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:obj];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:obj];
//    [obj removeObserver:self forKeyPath:@"downloadProgress"];
}

@end
