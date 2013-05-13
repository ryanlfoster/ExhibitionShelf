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
@synthesize listData = _listData;

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
    
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"background_main.jpg"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;

}

-(void)viewWillAppear:(BOOL)animated    //Called when the view is about to made visible. Default does nothing
{
    
    //modify _navigatioBar
    if([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [_navigationBar setBackgroundImage:[UIImage imageNamed:@"background_nav_top.jpg"] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    }
    
    SqliteService *sqliteService = [[SqliteService alloc] init];
    _listData = [sqliteService getAllDateFromTable];
    [self loadScrollViewData];
        
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

-(void)loadScrollViewData
{
    if(_containerView != nil){
        [_containerView removeFromSuperview];
    }
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 1024, 768)];
    _containerView.contentSize = CGSizeMake(0, 1900);
    _containerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_containerView];
    //load content in scrollView
    for(int i = 0 ; i < [_listData count] ; i++){
        ThirdCoverView *cover = [[ThirdCoverView alloc] initWithFrame:CGRectZero];
        Exhibition *exhibition = [_listData objectAtIndex:i];
        cover.exhibitionID = exhibition.exhibitionID;
        cover.title.text = exhibition.title;
        cover.file = exhibition.file;
        cover.cover.image = [UIImage imageWithContentsOfFile:exhibition.image];
        cover.delegateSelected = self;
        cover.delegateDeleted = self;
        NSInteger row = i/2;
        NSInteger col = i%2;
        CGRect coverFrame = cover.frame;
        coverFrame.origin = CGPointMake(col * CGRectGetWidth(coverFrame),CGRectGetHeight(coverFrame)*row);
        cover.frame = coverFrame;
        [_containerView addSubview:cover];
    }
}

#pragma mark - ShelfViewControllerProtocol implementation

-(void)coverSelected:(ThirdCoverView *)cover {
    
    NSLog(@"Selected !!!");
    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
    NSBundle *myBundle = [NSBundle bundleWithPath:cover.file];
    NSLog(@"myBundle = %@",myBundle);
    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
    viewController.navigationBarTitle = cover.title.text;
    //turn view
    if(viewController.str != nil){
        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:viewController animated:YES];
    }

    
}

-(void)coverDeleted:(ThirdCoverView *)cover
{
    NSLog(@"Deleted !!!");
    SqliteService *sqliteService = [[SqliteService alloc] init];
    [sqliteService deleteToDB:cover.exhibitionID];
    cover.alpha = 0.0;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *deleteDir = [CacheDirectory stringByAppendingPathComponent:cover.exhibitionID];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:deleteDir error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *fileName;
    while((fileName = [e nextObject])){
//        if([[fileName pathExtension] isEqualToString:@"png"])return;
        [fileManager removeItemAtPath:[deleteDir stringByAppendingPathComponent:fileName] error:NULL];
    }
  
}

#pragma mark - NSNotification
-(void)exhibitionDidEndDownload:(NSNotification *)notification {
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
    
}

-(void)exhibitionDidFailDownload:(NSNotification *)notification {
    Exhibition *exhibition = (Exhibition *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:exhibition];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:exhibition];
}



@end
