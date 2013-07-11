//
//  CustomTabBarButton.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomParentsViewController.h"

@interface CustomTabBarButton : NSObject
@property(nonatomic,strong)UIImage *icon;
@property(nonatomic,strong)UIImage *highlightedIcon;
@property(nonatomic,strong)CustomParentsViewController *viewController;

-(id)initWithIcon:(UIImage*)icon;

@end
