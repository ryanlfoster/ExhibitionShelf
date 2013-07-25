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
@synthesize playImageView = _playImageView;
@synthesize briefUILable = _briefUILable;
@synthesize exhibitionPath = _exhibitionPath;

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
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _playImageView.image = [UIImage imageNamed:@"playImageView.png"];
        _playImageView.userInteractionEnabled = YES;
        [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playExhibition:)]];
        [_playImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExhibition:)]];
        
        _briefUILable = [[BriefUILabel alloc] initWithFrame:CGRectMake(85, 0 + 4 + 120, 220, 52)];
        _briefUILable.titleLabel.textAlignment = UITextAlignmentCenter;
        _briefUILable.subTitleLabel.textAlignment = UITextAlignmentCenter;
        _briefUILable.dateLabel.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:_coverImageViewFrameView];
        [self addSubview:_coverImageView];
        [self addSubview:_playImageView];
        [self addSubview:_briefUILable];
    }
    return self;
}

#pragma mark - ShelfThirdViewControllerSelectedProtocol
/**********************************************************
 函数名称：-(void)clickCancelDownloadExhibition:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)playExhibition:(id)sender
{
    [_delegatePlay coverSelected:self];
}

-(void)deleteExhibition:(id)sender
{
    [_delegateDelete coverDeleted:self];
}

@end
