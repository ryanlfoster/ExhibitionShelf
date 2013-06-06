//
//  AboutUsViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦 鑫 on 5/26/13.
//  Copyright (c) 2013 TodaySybor. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize navigationBar = _navigationBar;
@synthesize backButton = _backButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_top.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:5 forBarMetrics:UIBarMetricsDefault];
    }
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(45.0f, 10.0f, 29.0f, 29.0f)];
    [_backButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backOnClick) forControlEvents:UIControlEventAllEvents];
    [_navigationBar addSubview:_backButton];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark -action
/**********************************************************
 函数名称：-(void)backOnClick
 函数描述：返回上一级
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)backOnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
