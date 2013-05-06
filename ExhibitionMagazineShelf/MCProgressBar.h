//
//  MCProgressBar.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-19.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProgressBar : UIView
-(id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;
@property(nonatomic,assign)float progress;
@end
