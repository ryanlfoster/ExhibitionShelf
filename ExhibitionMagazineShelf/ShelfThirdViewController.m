//
//  ShelfThirdViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfThirdViewController.h"
#import "Exhibition.h"
#import "ExhibitionStore.h"
#import "ThirdCoverView.h"
@interface ShelfThirdViewController ()
@end
@implementation ShelfThirdViewController
@synthesize exhibitionStore = _exhibitionStore;
@synthesize containerView = _containerView;
@synthesize navigationBar = _navigationBar;
@synthesize databasePath = _databasePath;

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"已下载";
        self.tabBarItem.image = [UIImage imageNamed:@"nav_download.png"];
    }
    return self;
}

- (void)viewDidLoad    //Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.

{
    [super viewDidLoad];

    /***************************************load View****************************************/
    
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"background_main.jpg"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    
    _containerView.contentSize = CGSizeMake(0, 1024);
    _containerView.showsVerticalScrollIndicator = NO;
    
}

-(void)viewWillAppear:(BOOL)animated    //Called when the view is about to made visible. Default does nothing
{
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_top.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    }
    
}

-(void)viewDidAppear:(BOOL)animated     //Called when the view has been fully transitioned onto the screen. Default does nothing
{
    
}

-(void)viewWillDisappear:(BOOL)animated     //Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
    
}

-(void)viewDidDisappear:(BOOL)animated     //Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    
}

- (void)viewDidUnload
{
    [self setContainerView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}


#pragma mark - ShelfViewControllerProtocol implementation

-(void)coverSelected:(ThirdCoverView *)cover {
    NSLog(@"Selected !!!!!!");
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    if(!selectedExhibition) {
        NSLog(@"NO selected Exhibition id !!!!!!!");
        return;
    }
    [self openZip:selectedExhibition];

}

-(void)coverDeleted:(ThirdCoverView *)cover
{
    NSLog(@"Deleted !!!!!");
}

#pragma mark - Actions
-(void)openZip:(Exhibition *)exhibition{
    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
    NSString *documentPath = [[[exhibition contentURL]URLByAppendingPathComponent:@"exhibition"]path];
    NSLog(@"documentPath:%@",documentPath);
    
    NSBundle *myBundle = [NSBundle bundleWithPath:documentPath];
    NSLog(@"myBundle:%@",myBundle);
    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
    viewController.navigationBarTitle = exhibition.title;
    //turn view
    if(viewController.str != nil){
        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:viewController animated:YES];
    }
}

@end
