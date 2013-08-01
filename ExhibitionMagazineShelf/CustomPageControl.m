//
//  CustomPageControl.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-5-22.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
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

/**
 *	hight light image
 *
 *	@param	imagePageStateHightlighted	transmit image
 */
-(void) setImagePageStateHightlighted:(UIImage *)imagePageStateHightlighted
{
    _imagePageStateHightlighted = imagePageStateHightlighted;
    [self updateDots];
}

/**
 *	normal image
 *
 *	@param	imagePageStateNormal	transmit image
 */
-(void)setImagePageStateNormal:(UIImage *)imagePageStateNormal
{
    _imagePageStateNormal = imagePageStateNormal;
    [self updateDots];
}

/**
 *	page view dots
 */
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

/**
 *	click dots jump to page view
 *
 *	@param	touch	touch event
 *	@param	event	UIEvent
 */
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
