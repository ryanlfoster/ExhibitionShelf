//
//  CustomTabBarButton.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-11.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "CustomTabBarButton.h"

@implementation CustomTabBarButton
@synthesize icon = _icon;
@synthesize highlightedIcon = _highlightedIcon;
@synthesize viewController = _viewController;

/**
 *	custom tab bar button init with icon
 *
 *	@param	icon	image icon
 *
 *	@return	custom tab bar button
 */
-(id)initWithIcon:(UIImage *)icon
{
    if (self = [super init]) {
        _icon = icon;
    }
    return self;
}

/**
 *	set view controller
 *
 *	@param	viewController	transmit viewcontroller
 */
-(void)setViewController:(CustomParentsViewController *)viewController
{
    _viewController = viewController;
    _viewController.customTabBarButton = self;
}

@end
