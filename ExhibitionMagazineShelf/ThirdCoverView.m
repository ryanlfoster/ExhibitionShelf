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
@synthesize cover = _cover;
@synthesize deleteButton = _deleteButton;
@synthesize viewButton = _viewButton;
@synthesize title = _title;
@synthesize description = _description;
@synthesize file = _file;

@synthesize delegateSelected = _delegateSelected;
@synthesize delegateDeleted = _delegateDeleted;

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
        self.frame = CGRectMake(0, 0, 512, 192);
        // title label
        _title = [[UILabel alloc] initWithFrame:CGRectMake(272, 40, 224, 40)];
        _title.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15.0];
        _title.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _title.textAlignment = UITextAlignmentLeft;
        _title.lineBreakMode = UILineBreakModeTailTruncation;
        _title.numberOfLines = 2;
        _title.backgroundColor = [UIColor clearColor];
        _title.shadowColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0f];
        _title.shadowOffset = CGSizeMake(0.1, 0.1);
        //description label
        _description = [[UILabel alloc] initWithFrame:CGRectMake(272, 80, 224, 76)];
        _description.font = [UIFont fontWithName:@"MicrosoftYaHei" size:12.0];
        _description.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0f];
        _description.backgroundColor = [UIColor clearColor];
        _description.textAlignment = UITextAlignmentLeft;
        _description.lineBreakMode = UILineBreakModeTailTruncation;
        _description.numberOfLines = 3;
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

#pragma mark -ShelfViewControllerProtocol
/**********************************************************
 函数名称：-(void)buttonCallback:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)buttonCallback:(id)sender
{
    
    [_delegateSelected coverSelected:self];
    
}

#pragma mark - delegate event,ShelfViewControllerProtocol,update view over delegate
/**********************************************************
 函数名称：-(void)deleteEvent:(id)sender
 函数描述：按钮点击协议方法
 输入参数：(id)sender：click
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)deleteEvent:(id)sender
{
    
    [_delegateDeleted coverDeleted:self];
    
}
@end
