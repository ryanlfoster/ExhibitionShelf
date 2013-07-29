//
//  ExhibitionShelfViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface ExhibitionShelfViewController : UIViewController<CustomTabBarDelegate>

@property (nonatomic, strong) CustomTabBar *customTabBar;
@property (nonatomic, strong) UINavigationBar *navigationBar;

@end
