//
//  ExhibitionViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ExhibitionViewController.h"

@interface ExhibitionViewController ()

@end

@implementation ExhibitionViewController
@synthesize str = _str;
@synthesize navigationBarTitle = _navigationBarTitle;
@synthesize backButton = _backButton;
@synthesize navigationBar = _navigationBar;
@synthesize webView = _webView;

#pragma mark -view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 43, 1024, 768-20-43)];
    
    if(_webView != nil){
        NSLog(@"_str = %@",_str);
        NSURL *htmlUrl = [NSURL fileURLWithPath:_str];
        [_webView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
    }
    [self.view addSubview:_webView];
     
    //custom navigationBar
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 1024, 43)];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 43)];
    titleLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:18.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _navigationBarTitle;
    titleLabel.textAlignment = UITextAlignmentCenter;
    UINavigationItem *titleNavigationItem = [[UINavigationItem alloc] init];
    titleNavigationItem.titleView = titleLabel;
    [_navigationBar pushNavigationItem:titleNavigationItem animated:NO];
    
    [self.view addSubview:_navigationBar];
    
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
