//
//  CustomTabBar.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate

-(void)switchViewController:(UIViewController*)vc;

@end

@interface CustomTabBar : UIView

@property(nonatomic,strong)NSMutableArray *buttonData;
@property(nonatomic,strong)NSMutableArray *buttons;

@property(nonatomic,weak)id<CustomTabBarDelegate>delegate;

-(id)initWithItems:(NSArray*)items;
-(void)touchDownForButton:(UIButton*)button;
-(void)touchUpForButton:(UIButton*)button;
-(void)showDefault;

@end
