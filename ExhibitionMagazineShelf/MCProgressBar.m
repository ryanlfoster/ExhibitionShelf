//
//  MCProgressBar.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-19.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "MCProgressBar.h"

@implementation MCProgressBar{
    UIImageView *_backgroundImageView;
    UIImageView *_foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
}

#pragma mark -init
/**********************************************************
 函数名称：- (id)initWithFrame:(CGRect)frame
 函数描述：初始化view
 输入参数：(CGRect)frame ：view 框架
 输出参数：n/a
 返回值：void
 **********************************************************/
-(id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage
{
    self = [super initWithFrame:frame];
    if(self){
        
        //progressBar background image
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = backgroundImage;
        [self addSubview:_backgroundImageView];
        
        //progressBar progress hint
        _foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _foregroundImageView.image = foregroundImage;
        [self addSubview:_foregroundImageView];
        
        //edge inset
        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        
    }
    
    return self;
}
/**********************************************************
 函数名称：-(void)setProgress:(float)progress
 函数描述：设置进度条
 输入参数：(float)progress：当前进度
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)setProgress:(float)progress
{
    _progress = progress;
    CGRect frame = _foregroundImageView.frame;
    frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
    _foregroundImageView.frame = frame;
}

@end
