//
//  CustomPageControl.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-5-22.
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

/**********************************************************
 函数名称：-(void) setImagePageStateHightlighted:(UIImage *)imagePageStateHightlighted
 函数描述：设置dots高亮显示
 输入参数：(UIImage *)imagePageStateHightlighted:高亮图片
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void) setImagePageStateHightlighted:(UIImage *)imagePageStateHightlighted
{
    _imagePageStateHightlighted = imagePageStateHightlighted;
    [self updateDots];
}
/**********************************************************
 函数名称：-(void) setImagePageStateHightlighted:(UIImage *)imagePageStateHightlighted
 函数描述：正常状态下的图片样式
 输入参数：(UIImage *)imagePageStateHightlighted:默认图片
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)setImagePageStateNormal:(UIImage *)imagePageStateNormal
{
    _imagePageStateNormal = imagePageStateNormal;
    [self updateDots];
}
/**********************************************************
 函数名称：updateDots
 函数描述：更新dots样式
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
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
/**********************************************************
 函数名称：-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
 函数描述：触摸dots跳转
 输入参数：(UITouch *)touch：触摸方式 withEvent:(UIEvent *)event：点击时事件
 输出参数：n/a
 返回值：void
 **********************************************************/
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
