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
@synthesize button = _button;
@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // frame
        self.frame = CGRectMake(0, 0, 512, 192);
        // title label
        _title = [[UILabel alloc] initWithFrame:CGRectMake(272, 50, 224, 40)];
        _title.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16.0];
        _title.textColor=[UIColor blackColor];
        _title.backgroundColor=[UIColor clearColor];
        _title.textAlignment=UITextAlignmentLeft;
        _title.lineBreakMode = UILineBreakModeWordWrap;
        _title.numberOfLines = 0;
        //imageView
        _cover = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 202, 142)];
        _cover.userInteractionEnabled = YES;
        [_cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonCallback:)]];
        //circol corner image
        CALayer *layer = [_cover layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:10.0];
        //add image border
        //        layer.borderColor = [[UIColor blackColor]CGColor];
        //        layer.borderWidth = 5.0f;
        // progress
        // button
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"view_button.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonCallback:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"观看" forState:UIControlStateNormal];
        _button.frame=CGRectMake(272, 166, 76, 26);
        
        [self addSubview:_title];
        [self addSubview:_cover];
        [self addSubview:_button];


    }
    return self;
}

#pragma mark - Callbacks,ShelfViewControllerProtocol,update view over delegate

-(void)buttonCallback:(id)sender {
    
    [_delegate coverSelected:self];
}



@end
