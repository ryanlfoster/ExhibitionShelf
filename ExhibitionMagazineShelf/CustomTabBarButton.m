//
//  CustomTabBarButton.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "CustomTabBarButton.h"

@implementation CustomTabBarButton
@synthesize icon = _icon;
@synthesize highlightedIcon = _highlightedIcon;
@synthesize viewController = _viewController;

-(id)initWithIcon:(UIImage *)icon
{
    if (self = [super init]) {
        _icon = icon;
    }
    return self;
}

-(void)setViewController:(CustomParentsViewController *)viewController
{
    _viewController = viewController;
    _viewController.customTabBarButton = self;
}

@end
