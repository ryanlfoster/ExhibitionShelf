//
//  ShelfFivethViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-23.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfFivethViewController.h"

@interface ShelfFivethViewController ()

@end

@implementation ShelfFivethViewController
@synthesize navigationBar = _navigationBar;
@synthesize label = _label;
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.tabBarItem.title = @"帮助";
        self.tabBarItem.image = [UIImage imageNamed:@"nav_help.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /***************************************load View****************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"background_main.jpg"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    
    _label.lineBreakMode = UILineBreakModeWordWrap;
    _label.numberOfLines = 0;
    _label.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20.0];
    _label.text = @"       今日数字美术馆 – Today Digital Art Museum，始创于2009年，是以“互联网和移动终端”为载体进行艺术推介、展览展示、电子出版和艺术史记录的数字化平台。它整合了现代科技在当代艺术实践及展示交流中的核心优势，是21世纪全球化语境中的新型动态美术馆 – 可移动的、永不落幕的美术馆。";

    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setLabel:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
