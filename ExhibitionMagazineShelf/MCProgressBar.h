//
//  MCProgressBar.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-19.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProgressBar : UIView

@property (nonatomic, assign) float progress;

-(id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@end
