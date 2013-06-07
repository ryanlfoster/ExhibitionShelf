//
//  ShelfAppDelegate.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfAppDelegate.h"
#import "ShelfFirstViewController.h"
#import "ShelfThirdViewController.h"
#import "ShelfFourthViewController.h"
#import "Reachability.h"
@implementation ShelfAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /************************************Reachability****************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:EXHIBITIONLIST];
    
    [reach startNotifier];
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[ShelfFirstViewController alloc] initWithNibName:@"ShelfFirstViewController" bundle:nil];
    UIViewController *viewController3 = [[ShelfThirdViewController alloc] initWithNibName:@"ShelfThirdViewController" bundle:nil];
    UIViewController *viewController4 = [[ShelfFourthViewController alloc] initWithNibName:@"ShelfFourthViewController" bundle:nil];
    
    //all add to tab bar controller
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController3, viewController4];
    
    //set tab bar title style
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"MicrosoftYaHei" size:11.0],UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    //set tab bar background
    UIImage *backgroundImageNav = [UIImage imageNamed:@"tabbar_background.png"];
    self.tabBarController.tabBar.backgroundImage = backgroundImageNav;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    //set tab bar item selected background
    UIImage *backgroundImageBtnNav = [UIImage imageNamed:@"tab_bar_btn_press_108.png"];
    self.tabBarController.tabBar.selectionIndicatorImage = backgroundImageBtnNav;
    self.tabBarController.tabBar.selectedImageTintColor  = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

/**********************************************************
 函数名称：-(void)reachabilityChanged:(NSNotification *)note
 函数描述：使用了支持ARC\GCD的网络监测
 输入参数：(NSString *)statu：某状态。
 输出参数：(int *)roomCount ：该状态房间数量。
 返回值：BOOL：操作是否成功。
 **********************************************************/
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reach = [note object];
    if(![reach isReachable])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本软件需要联网后使用，请确保您的网络通畅" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"main to background"); 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"background to main");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
