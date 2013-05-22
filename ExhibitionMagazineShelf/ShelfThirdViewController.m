//
//  ShelfThirdViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfThirdViewController.h"
#import "ThirdCoverView.h"
#import "Exhibition.h"

@implementation ShelfThirdViewController
@synthesize containerView = _containerView;
@synthesize navigationBar = _navigationBar;
@synthesize listData = _listData;

@synthesize alertString = _alertString;
@synthesize alertViewThird = _alertViewThird;

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
        cover.description.text = exhibition.description;
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

#pragma mark - ShelfThirdViewControllerSelectedProtocol implementation

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

#pragma mark - ShelfThirdViewControllerDeletedProtocol implementation

-(void)coverDeleted:(ThirdCoverView *)cover
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真的要删除嘛?" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回", nil];
    [alert show];
    
    //variable control UIAlertViewDelegate
    _alertViewThird = cover;
    _alertString = cover.exhibitionID;
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        //delete table 
        SqliteService *sqliteService = [[SqliteService alloc] init];
        [sqliteService deleteToDB:_alertString];
        
        //hide view
        _alertViewThird.alpha = 0.0;
        
        //delete dir
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *deleteDir = [CacheDirectory stringByAppendingPathComponent:_alertString];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:deleteDir error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *fileName;
        while((fileName = [e nextObject])){
            if(![[fileName pathExtension] isEqualToString:@"png"]){
                [fileManager removeItemAtPath:[deleteDir stringByAppendingPathComponent:fileName] error:NULL];
            }
            
        }

    }else return;
}

@end
