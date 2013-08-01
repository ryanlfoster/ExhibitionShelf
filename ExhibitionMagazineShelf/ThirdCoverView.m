//
//  ThirdCoverView.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-15.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // frame
        self.frame = CGRectMake(85, 0, 222, 266);
        
        _coverImageViewFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _coverImageViewFrameView.image = [UIImage imageNamed:@"image_layout.png"];
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 + 4, 0 + 4, 212, 194)];
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 220, 202)];
        _playImageView.image = [UIImage imageNamed:@"play_frame.png"];
        _playImageView.userInteractionEnabled = YES;
        [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playExhibition:)]];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExhibition:)];
        longPressGR.allowableMovement = NO;
        longPressGR.minimumPressDuration = 0.3;
        [_playImageView addGestureRecognizer:longPressGR];
        
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

/**
 *	delegatePlay click
 *
 *	@param	sender	sender
 */
-(void)playExhibition:(id)sender
{
    [_delegatePlay coverSelected:self];
}

/**
 *	delegateDelete click
 *
 *	@param	sender	sender
 */
-(void)deleteExhibition:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    [_delegateDelete coverDeleted:self];
}

@end
