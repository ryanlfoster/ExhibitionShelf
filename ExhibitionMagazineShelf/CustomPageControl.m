//
//  CustomPageControl.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-5-22.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "CustomPageControl.h"

@interface CustomPageControl(Private)
-(void) updateDots;
@end

@implementation CustomPageControl

@synthesize imagePageStateHightlighted = _imagePageStateHightlighted;
@synthesize imagePageStateNormal = _imagePageStateNormal;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setImagePageStateHightlighted:(UIImage *)imagePageStateHightlighted
{
    _imagePageStateHightlighted = imagePageStateHightlighted;
    [self updateDots];
}
-(void)setImagePageStateNormal:(UIImage *)imagePageStateNormal
{
    _imagePageStateNormal = imagePageStateNormal;
    [self updateDots];
}
-(void)updateDots
{
    if(_imagePageStateNormal || _imagePageStateHightlighted)
    {
        NSArray *subView = self.subviews;
        for(int i = 0 ; i < [subView count]; i++)
        {
            UIImageView *dot = [subView objectAtIndex:i];
            dot.image = (self.currentPage == i ? _imagePageStateHightlighted : _imagePageStateNormal);
        }
    }
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
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
