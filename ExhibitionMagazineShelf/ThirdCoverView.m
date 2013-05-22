//
//  ThirdCoverView.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ThirdCoverView.h"
#import "Exhibition.h"
@implementation ThirdCoverView
@synthesize exhibitionID = _exhibitionID;
@synthesize cover = _cover;
@synthesize deleteButton = _deleteButton;
@synthesize viewButton = _viewButton;
@synthesize title = _title;
@synthesize description = _description;
@synthesize file = _file;

@synthesize delegateSelected = _delegateSelected;
@synthesize delegateDeleted = _delegateDeleted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // frame
        self.frame = CGRectMake(0, 0, 512, 192);
        // title label
        _title = [[UILabel alloc] initWithFrame:CGRectMake(272, 50, 224, 42)];
        _title.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16.0];
        _title.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _title.lineBreakMode = UILineBreakModeWordWrap;
        _title.numberOfLines = 0;
        _title.backgroundColor = [UIColor clearColor];
        //description label
        _description = [[UILabel alloc] initWithFrame:CGRectMake(272, 98, 224, 50)];
        _description.font = [UIFont fontWithName:@"MicrosoftYaHei" size:12.0];
        _description.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0f];
        _description.backgroundColor = [UIColor clearColor];
        _description.textAlignment = UITextAlignmentLeft;
        _description.lineBreakMode = UILineBreakModeWordWrap;
        _description.numberOfLines = 0;
        //imageView
        _cover = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 202, 169)];
        _cover.userInteractionEnabled = YES;
        [_cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonCallback:)]];
        //delete button
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"cancel_button.png"]forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14.0];
        [_deleteButton setTitle:@"删 除" forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(358, 166, 76, 26);
        // view button
        _viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewButton setBackgroundImage:[UIImage imageNamed:@"view_button.png"] forState:UIControlStateNormal];
        [_viewButton addTarget:self action:@selector(buttonCallback:) forControlEvents:UIControlEventTouchUpInside];
        _viewButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14.0];
        [_viewButton setTitle:@"观 看" forState:UIControlStateNormal];
        _viewButton.frame=CGRectMake(272, 166, 76, 26);
        
        [self addSubview:_title];
        [self addSubview:_description];
        [self addSubview:_cover];
        [self addSubview:_viewButton];
        [self addSubview:_deleteButton];


    }
    return self;
}

#pragma mark - Callbacks,ShelfViewControllerProtocol,update view over delegate

-(void)buttonCallback:(id)sender
{
    
    [_delegateSelected coverSelected:self];
    
}

#pragma mark - delegate event,ShelfViewControllerProtocol,update view over delegate

-(void)deleteEvent:(id)sender
{
    
    [_delegateDeleted coverDeleted:self];
    
}



@end
