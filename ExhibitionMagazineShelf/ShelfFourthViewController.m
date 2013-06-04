//
//  ShelfFourthViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfFourthViewController.h"
#import "Reachability.h"
#import "AboutUsViewController.h"
@interface ShelfFourthViewController ()

@end

@implementation ShelfFourthViewController
@synthesize navigationBar = _navigationBar;
@synthesize aboutusButton = _aboutusButton;

#pragma mark -nib init

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

#pragma mark -View lifecycle

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
        [_navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor, nil]];
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
/**********************************************************
 函数名称：-(void)aboutusButtonAction
 函数描述：按钮功能，关于我们
 输入参数：n/a
 输出参数：aboutUsViewController
 返回值：void
 **********************************************************/
-(void)aboutusButtonAction
{
    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
    [aboutUsViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:aboutUsViewController animated:YES];;
}

@end
