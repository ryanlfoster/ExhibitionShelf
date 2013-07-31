//
//  ShareView.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-31.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView
@synthesize shareFrame = _shareFrame;
@synthesize coverImageView = _coverImageView;
@synthesize briefLabel = _briefLabel;
@synthesize sharePanel = _sharePanel;
@synthesize panelTip = _panelTip;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(160, 160, 222, 550);
        
        _shareFrame = [[UIImageView alloc] initWithFrame:CGRectMake(160, 160, 220, 202)];
        _shareFrame.image = [UIImage imageNamed:@"shareFrame.png"];
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160 + 4, 160 + 4, 212, 194)];
        
        _briefLabel = [[BriefUILabel alloc] initWithFrame:CGRectMake(160, 160 + 4 + 120, 220, 52)];
        _briefLabel.titleLabel.textAlignment = UITextAlignmentCenter;
        _briefLabel.subTitleLabel.textAlignment = UITextAlignmentCenter;
        _briefLabel.dateLabel.textAlignment = UITextAlignmentCenter;
        [_briefLabel changeGreen];
        
        _sharePanel = [[UIImageView alloc] initWithFrame:CGRectMake(160, 160 + 202 + 10, 220, 330)];
        _sharePanel.image = [UIImage imageNamed:@"share_panel.png"];
        
        [self addSubview:_shareFrame];
        [self addSubview:_coverImageView];
        [self addSubview:_briefLabel];
        [self addSubview:_shareFrame];
        [self addSubview:_panelTip];
        
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
