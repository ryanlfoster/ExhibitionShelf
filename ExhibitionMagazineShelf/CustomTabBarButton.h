//
//  CustomTabBarButton.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-11.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomParentsViewController.h"

@interface CustomTabBarButton : NSObject

@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, strong) UIImage *highlightedIcon;
@property(nonatomic, strong) CustomParentsViewController *viewController;

-(id)initWithIcon:(UIImage*)icon;

@end
