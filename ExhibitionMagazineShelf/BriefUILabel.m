//
//  BriefUILabel.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-15.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "BriefUILabel.h"

@implementation BriefUILabel
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
        _titleLabel.font = [UIFont fontWithName:@"FZYDCHJW--GB1-0" size:18.0];
        _titleLabel.textColor = [UIColor colorWithRed:89.0/255 green:89.0/255 blue:89.0/255 alpha:1.0f];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 220, 16)];
        _subTitleLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:14.0];
        _subTitleLabel.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0f];
        _subTitleLabel.textAlignment = UITextAlignmentLeft;
        _subTitleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 220, 12)];
        _dateLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:10.0];
        _dateLabel.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0f];
        _dateLabel.textAlignment = UITextAlignmentLeft;
        _dateLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _dateLabel.numberOfLines = 1;
        _dateLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_titleLabel];
        [self addSubview:_subTitleLabel];
        [self addSubview:_dateLabel];
    }
    return self;
}

-(void)changeGreen
{
    _titleLabel.textColor = [UIColor colorWithRed:196.0/255 green:215.0/255 blue:15.0/255 alpha:1.0f];
    _subTitleLabel.textColor = [UIColor colorWithRed:196.0/255 green:215.0/255 blue:15.0/255 alpha:1.0f];
    _dateLabel.textColor = [UIColor colorWithRed:196.0/255 green:215.0/255 blue:15.0/255 alpha:1.0f];
}

-(void)changeNormal
{
    _titleLabel.textColor = [UIColor colorWithRed:89.0/255 green:89.0/255 blue:89.0/255 alpha:1.0f];
    _subTitleLabel.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0f];
    _dateLabel.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0f];
}

@end
