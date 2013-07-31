//
//  CustomTabBar.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "CustomTabBar.h"
#import "CustomTabBarButton.h"

@interface CustomTabBar()

@property (nonatomic, strong) NSMutableArray *buttonData;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) PlaySoundTools *sound;

@end

@implementation CustomTabBar
@synthesize buttons = _buttons;
@synthesize delegate = _delegate;
@synthesize buttonData = _buttonData;
@synthesize sound = _sound;

/**
 *	init custom bar with items
 *
 *	@param	items	NSArray button
 *
 *	@return	custom bar
 */
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

/**
 *	set buttons in custom bar
 */
-(void)setButtons
{
    NSInteger count = 0;
    _buttons = [[NSMutableArray alloc] init];
    for (CustomTabBarButton *info in _buttonData) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(212 +(150*count), 0, 145, 35);
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

/**
 *	touch down button
 *
 *	@param	button	button which in array
 */
-(void)touchDownForButton:(UIButton*)button
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"actionsheet" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
    
    [button setSelected:YES];
    NSInteger i = [_buttons indexOfObject:button];
    UIViewController *vc = [[_buttonData objectAtIndex:i] viewController];
    [_delegate switchViewController:vc];
    [vc viewWillAppear:YES];
}

/**
 *	touch up
 *
 *	@param	button	button which in array
 */
-(void)touchUpForButton:(UIButton*)button
{
    for (UIButton *button in _buttons) {
        [button setSelected:NO];
    }
    [button setSelected:YES];
}

/**
 *	default show custom bar
 */
-(void)showDefault
{
    [self touchDownForButton:[_buttons objectAtIndex:0]];
    [self touchUpForButton:[_buttons objectAtIndex:0]];
}

@end
