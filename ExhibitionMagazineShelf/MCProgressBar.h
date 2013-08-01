//
//  MCProgressBar.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-19.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProgressBar : UIView

@property (nonatomic, assign) float progress;

-(id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@end
