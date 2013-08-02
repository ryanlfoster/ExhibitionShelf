//
//  ShareView.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-31.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView
@synthesize shareFrame = _shareFrame;
@synthesize coverImageView = _coverImageView;
@synthesize briefLabel = _briefLabel;
@synthesize sharePanel = _sharePanel;
@synthesize panelTip = _panelTip;
@synthesize panelTipExtend = _panelTipExtend;
@synthesize panelTipAdd = _panelTipAdd;
@synthesize shareButton = _shareButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // X : 89.5 = (1024 - 3 * 222) / 4
        // Y : 60 = (670 - 550) / 2
        self.frame = CGRectMake(89.5, 60, 222, 550);
        
        _shareFrame = [[UIImageView alloc] initWithFrame:CGRectMake(89.5, 70, 220, 202)];
        _shareFrame.image = [UIImage imageNamed:@"share_frame.png"];
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(89.5 + 4, 70 + 4, 212, 194)];
        
        _briefLabel = [[BriefUILabel alloc] initWithFrame:CGRectMake(89.5, 70 + 4 + 120, 220, 52)];
        _briefLabel.titleLabel.textAlignment = UITextAlignmentCenter;
        _briefLabel.subTitleLabel.textAlignment = UITextAlignmentCenter;
        _briefLabel.dateLabel.textAlignment = UITextAlignmentCenter;
        [_briefLabel changeGreen];
        
        _sharePanel = [[UIImageView alloc] initWithFrame:CGRectMake(89.5, 70 + 202 + 10, 220, 330)];
        _sharePanel.image = [UIImage imageNamed:@"share_panel.png"];
        
        _panelTip = [[UILabel alloc] initWithFrame:CGRectMake(89.5 + 16, 70 + 202 + 40, 200, 12)];
        _panelTip.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:12.0f];
        _panelTip.textColor=[UIColor blackColor];
        _panelTip.lineBreakMode = UILineBreakModeTailTruncation;
        _panelTip.numberOfLines = 2;
        _panelTip.backgroundColor = [UIColor clearColor];
        _panelTip.text = @"看展览全景视频，今日数字美术馆";
        
        _panelTipExtend = [[UILabel alloc] initWithFrame:CGRectMake(89.5 + 16, 70 + 202 + 40 + 36, 200, 12)];
        _panelTipExtend.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:12.0f];
        _panelTipExtend.textColor=[UIColor blackColor];
        _panelTipExtend.lineBreakMode = UILineBreakModeTailTruncation;
        _panelTipExtend.numberOfLines = 2;
        _panelTipExtend.backgroundColor = [UIColor clearColor];
        _panelTipExtend.text = @"感谢分享您的评论。";
        
        _panelTipAdd = [[UILabel alloc] initWithFrame:CGRectMake(89.5 + 16, 70 + 202 + 40 + 36 + 4 * 36 - 8, 200, 12)];
        _panelTipAdd.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:12.0f];
        _panelTipAdd.textColor=[UIColor grayColor];
        _panelTipAdd.backgroundColor = [UIColor clearColor];
        _panelTipAdd.textAlignment = UITextAlignmentCenter;
        _panelTipAdd.text = @"评论请不要超过120字。";
        
        _shareButton = [[UIImageView alloc] initWithFrame:CGRectMake(89.5 + ((220 / 2) - (18 / 2)), 70 + 202 + 40 + 36 + 4 * 36 + 18, 36 / 2, 57 / 2)];
        _shareButton.image = [UIImage imageNamed:@"share_button.png"];
        
        
        [self addSubview:_coverImageView];
        [self addSubview:_shareFrame];
        [self addSubview:_briefLabel];
        [self addSubview:_sharePanel];
        [self addSubview:_panelTip];
        [self addSubview:_panelTipExtend];
        [self addSubview:_panelTipAdd];
        [self addSubview:_shareButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
