//
//  BriefUILabel.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
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
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _titleLabel.shadowOffset = CGSizeMake(0.1, 0.1);
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 220, 15)];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _subTitleLabel.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _subTitleLabel.textAlignment = UITextAlignmentLeft;
        _subTitleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.shadowColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _subTitleLabel.shadowOffset = CGSizeMake(0.1, 0.1);
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 220, 10)];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        _dateLabel.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _dateLabel.textAlignment = UITextAlignmentLeft;
        _dateLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _dateLabel.numberOfLines = 1;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.shadowColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _dateLabel.shadowOffset = CGSizeMake(0.1, 0.1);
        
        [self addSubview:_titleLabel];
        [self addSubview:_subTitleLabel];
        [self addSubview:_dateLabel];
    }
    return self;
}



@end
