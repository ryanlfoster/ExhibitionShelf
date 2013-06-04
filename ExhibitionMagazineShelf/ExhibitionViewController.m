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
@synthesize navigationBarTitle;
@synthesize backButton = _backButton;

#pragma mark -view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 1024, 768 - 80)];
    
    if(webView != nil){
        NSLog(@"_str = %@",_str);
        NSURL *htmlUrl = [NSURL fileURLWithPath:_str];
        [webView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
    }
    [self.view addSubview:webView];
     
    //custom navigationBar
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
    navigationBar.tintColor = [UIColor blackColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = navigationBarTitle;
    [self.view addSubview:navigationBar];
    [navigationBar pushNavigationItem:navItem animated:YES];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(45.0f, 10.0f, 29.0f, 29.0f)];
    [_backButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backOnClick) forControlEvents:UIControlEventAllEvents];
    [navigationBar addSubview:_backButton];

    
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
