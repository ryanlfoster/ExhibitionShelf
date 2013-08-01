//
//  CustomTabBar.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-11.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "PlaySoundTools.h"

@protocol CustomTabBarDelegate

-(void)switchViewController:(UIViewController*)vc;

@end

@interface CustomTabBar : UIView

@property(nonatomic, weak) id<CustomTabBarDelegate>delegate;

-(id)initWithItems:(NSArray*)items;
-(void)touchDownForButton:(UIButton*)button;
-(void)touchUpForButton:(UIButton*)button;
-(void)showDefault;

@end
