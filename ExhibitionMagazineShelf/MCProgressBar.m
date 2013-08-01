//
//  MCProgressBar.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-19.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "MCProgressBar.h"

@implementation MCProgressBar{
    
    UIImageView *_backgroundImageView;
    UIImageView *_foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
    
}

/**
 *	init progress
 *
 *	@param	frame	frame
 *	@param	backgroundImage	background image
 *	@param	foregroundImage	foreground image
 *
 *	@return	progress
 */
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
/**
 *	set progress
 *
 *	@param	progress	transmit progress
 */
-(void)setProgress:(float)progress
{
    _progress = progress;
    CGRect frame = _foregroundImageView.frame;
    frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
    _foregroundImageView.frame = frame;
}

@end
