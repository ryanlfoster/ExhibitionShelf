//
//  ExhibitionShelfViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ExhibitionShelfViewController.h"
#import "CustomTabBarButton.h"
#import "CustomParentsViewController.h"
#import "ShelfFirstViewController.h"
#import "ShelfThirdViewController.h"
#import "AboutUsViewController.h"

@interface ExhibitionShelfViewController ()

@end

@implementation ExhibitionShelfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ShelfFirstViewController *evc = [[ShelfFirstViewController alloc] init];
    CustomTabBarButton *tabBarButtonEVC = [[CustomTabBarButton alloc] initWithIcon:[UIImage imageNamed:@"tabbar_exhibitiondisplay.png"]];
    tabBarButtonEVC.highlightedIcon = [UIImage imageNamed:@"tabbar_exhibitiondisplay_highly.png"];
    tabBarButtonEVC.viewController = evc;
    
    ShelfThirdViewController *mvc = [[ShelfThirdViewController alloc] init];
    CustomTabBarButton *tabBarButtonMVC = [[CustomTabBarButton alloc] initWithIcon:[UIImage imageNamed:@"tabbar_myexhibition.png"]];
    tabBarButtonMVC.highlightedIcon = [UIImage imageNamed:@"tabbar_myexhibition_highly.png"];
    tabBarButtonMVC.viewController = mvc;
    
    AboutUsViewController *avc = [[AboutUsViewController alloc] init];
    CustomTabBarButton *tabBarButtonAVC = [[CustomTabBarButton alloc] initWithIcon:[UIImage imageNamed:@"tabbar_aboutus.png"]];
    tabBarButtonAVC.highlightedIcon = [UIImage imageNamed:@"tabbar_aboutus_highly.png"];
    tabBarButtonAVC.viewController = avc;
    
    NSArray *array = [NSArray arrayWithObjects:tabBarButtonEVC,tabBarButtonMVC,tabBarButtonAVC, nil];
    _customTabBar = [[CustomTabBar alloc] initWithItems:array];
    _customTabBar.delegate = self;
    [self.view addSubview:_customTabBar];
    [_customTabBar showDefault];
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 1024, 43)];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 43)];
    titleLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:18.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"今日数字美术馆";
    titleLabel.textAlignment = UITextAlignmentCenter;
    UINavigationItem *titleNavigationItem = [[UINavigationItem alloc] init];
    titleNavigationItem.titleView = titleLabel;
    [_navigationBar pushNavigationItem:titleNavigationItem animated:NO];
    
    [self.view addSubview:_navigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchViewController:(UIViewController *)vc
{
    vc.view.frame = CGRectMake(0, _navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - _customTabBar.frame.size.height);
    [self.view insertSubview:vc.view belowSubview:_customTabBar];
}

@end
