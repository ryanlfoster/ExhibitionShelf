//
//  CustomTabBar.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
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
