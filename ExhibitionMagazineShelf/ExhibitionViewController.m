//
//  ExhibitionViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ExhibitionViewController.h"

@interface ExhibitionViewController ()

@end

@implementation ExhibitionViewController
@synthesize str = _str;
@synthesize navigationBarTitle;

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
    [self.view addSubview:navigationBar];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backOnClick)];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"观看网页版" style:UIBarButtonItemStylePlain target:self action:@selector(openSafari)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.leftBarButtonItem = leftButton;
//    navItem.rightBarButtonItem = rightButton;
    navItem.title = navigationBarTitle;
    
    [navigationBar pushNavigationItem:navItem animated:YES];
}

//back to before view
-(void)backOnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

//overturn
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

@end
