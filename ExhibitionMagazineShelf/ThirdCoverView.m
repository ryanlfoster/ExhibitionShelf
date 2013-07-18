//
//  ThirdCoverView.m
//  ExhibitionMagazineShelf
//
//  Created by秦鑫 on 13-4-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ThirdCoverView.h"
#import "Exhibition.h"
@implementation ThirdCoverView
@synthesize exhibitionID = _exhibitionID;
@synthesize coverImageViewFrameView = _coverImageViewFrameView;
@synthesize coverImageView = _coverImageView;
@synthesize coverImageViewDownloading = _coverImageViewDownloading;
@synthesize coverImageViewReadyPlay = _coverImageViewReadyPlay;
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
        // frame
        self.frame = CGRectMake(85, 0, 222, 266);
        _coverImageViewFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _coverImageViewFrameView.image = [UIImage imageNamed:@"imagelayout.png"];
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 + 4, 0 + 4, 212, 194)];
        _coverImageViewDownloading = [[UIImageView alloc] initWithFrame:CGRectMake(85 + 4, 0 + 4 + 96, 212, 30)];
        _coverImageViewReadyPlay = [[UIImageView alloc] initWithFrame:CGRectMake(85 + 4, 0 + 4 + 96, 212, 30)];
        _coverImageViewReadyPlay.userInteractionEnabled = YES;
        [_coverImageViewReadyPlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playExhibition:)]];
        _briefUILable = [[BriefUILabel alloc] initWithFrame:CGRectMake(85, 0 + 4 + 96 + 30, 212, 60)];
        _progressBar = [[MCProgressBar alloc] initWithFrame:CGRectMake(85, 0 + 4 + 96 + 30 + 60, 212, 16)];
        
        [self addSubview:_coverImageViewFrameView];
        [self addSubview:_coverImageView];
        [self addSubview:_coverImageViewDownloading];
        [self addSubview:_coverImageViewReadyPlay];
        [self addSubview:_briefUILable];
        [self addSubview:_progressBar];
        
    }
    return self;
}

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

@end
