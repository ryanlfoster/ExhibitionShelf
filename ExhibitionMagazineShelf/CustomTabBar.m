//
//  CustomTabBar.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "CustomTabBar.h"
#import "CustomTabBarButton.h"

@implementation CustomTabBar
@synthesize buttons = _buttons;
@synthesize delegate = _delegate;
@synthesize buttonData = _buttonData;

-(id)initWithItems:(NSArray *)items
{
    if(self = [super init]){
        self.frame = CGRectMake(0, 768-54, 1024, 35);
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
        _buttonData = [[NSMutableArray alloc] initWithArray:items];
        [self setButtons];
    }
    return self;
}

-(void)setButtons
{
    NSInteger count = 0;
    _buttons = [[NSMutableArray alloc] init];
    for (CustomTabBarButton *info in _buttonData) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(264 +(168*count), 0, 162, 35);
        [button setImage:info.icon forState:UIControlStateNormal];
        [button setImage:info.highlightedIcon forState:UIControlStateHighlighted];
        [button setImage:info.highlightedIcon forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [_buttons addObject:button];
        count++;
    }
}

-(void)touchDownForButton:(UIButton*)button
{
    [button setSelected:YES];
    NSInteger i = [_buttons indexOfObject:button];
    UIViewController *vc = [[_buttonData objectAtIndex:i] viewController];
    [_delegate switchViewController:vc];
}

-(void)touchUpForButton:(UIButton*)button
{
    for (UIButton *button in _buttons) {
        [button setSelected:NO];
    }
    [button setSelected:YES];
}

-(void)showDefault
{
    [self touchDownForButton:[_buttons objectAtIndex:0]];
    [self touchUpForButton:[_buttons objectAtIndex:0]];
}

@end
