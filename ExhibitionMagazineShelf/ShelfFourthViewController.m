//
//  ShelfFourthViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfFourthViewController.h"

@interface ShelfFourthViewController ()

@end

@implementation ShelfFourthViewController
@synthesize navigationBar = _navigationBar;
@synthesize webView = _webView;
@synthesize progressHUD = _progressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.tabBarItem.title = @"关于我们";
        self.tabBarItem.image = [UIImage imageNamed:@"nav_aboutus.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *string = [NSString stringWithFormat:@"http://www.vrdam.com/news/aboutus.html"];
    NSString *stringURL = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:stringURL];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_top.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

@end
