//
//  ShelfFourthViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfFourthViewController.h"
#import "Reachability.h"
@interface ShelfFourthViewController ()

@end

@implementation ShelfFourthViewController
@synthesize navigationBar = _navigationBar;
@synthesize aboutusButton = _aboutusButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.tabBarItem.title = @"使用指南";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_compress.png"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_bottom.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:5 forBarMetrics:UIBarMetricsDefault];
    }
    
    _aboutusButton = [[UIButton alloc] initWithFrame:CGRectMake(930.0f, 10.0f, 29.0f, 29.0f)];
    [_aboutusButton setImage:[UIImage imageNamed:@"btn_aboutus.png"] forState:UIControlStateNormal];
    [_navigationBar addSubview:_aboutusButton];
    
    [_aboutusButton addTarget:self action:@selector(aboutusButtonAction) forControlEvents:UIControlEventAllEvents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

#pragma mark - Actions

-(void)aboutusButtonAction
{
    return;
}

@end
