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
-(void)selectDB;
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

- (void)viewDidLoad    //Called after the view has been loaded. For view controllers created in code, this is after -loadView. For          view controllers unarchived from a nib, this is after the view is set.
{
    [super viewDidLoad];
    
    [self selectDB];
    
    /***************************************load View****************************************/
    
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"background_main.jpg"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    
    _containerView.contentSize = CGSizeMake(0, 1024);
    _containerView.showsVerticalScrollIndicator = NO;
    
//    exhibitionDownloadedArray = [[NSMutableArray alloc]init];
    
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

#pragma mark - Private
-(void)selectDB
{
    //according db create a table contacet(id dbTitle dbPathCoverImg dbPathFile)
    NSString *docDir;//db path
    NSArray *pathsDir;//document directory
    
    pathsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = [pathsDir objectAtIndex:0];
    
    //build the path to the database file
    _databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:@"exhibition.db"]];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if(sqlite3_open(dbpath, &exhibitionDB)==SQLITE_OK){
        
        //        NSString *countString;//data count
        NSString *title;//data title
        NSString *image;//data image path
        NSString *file;//data file path
        
        //caculate count that save to exhibition
        //        NSString *countSQL = [NSString stringWithFormat:@"SELECT COUNT(*) from exhibition"];
        //        const char *query_stmt_count =[countSQL UTF8String];
        //        if(sqlite3_prepare_v2(exhibitionDB, query_stmt_count, -1, &statement, NULL) == SQLITE_OK){
        //            if(sqlite3_step(statement) == SQLITE_ROW){
        //                 countString = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
        //            }
        //        }
        
        //select title\image\file from exhibition
        NSString *querySQL = [NSString stringWithFormat:@"SELECT title,image,file from exhibition"];
        const char *query_stmt_select = [querySQL UTF8String];
        if(sqlite3_prepare_v2(exhibitionDB, query_stmt_select, -1, &statement, NULL) == SQLITE_OK){
            
            int i = 0;
            int j = 0;
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                ThirdCoverView *cover = [[ThirdCoverView alloc] initWithFrame:CGRectZero];
                title = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];NSLog(@"%@",title);
                cover.title.text = title;
                
                image = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];NSLog(@"%@",image);
                cover.cover.image = [UIImage imageWithContentsOfFile:image];
                
                file = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];NSLog(@"%@",file);
                
                cover.delegate = self;
                cover.exhibitionID = [NSString stringWithFormat:@"%d",i++];
                
                NSInteger row = j/2;
                NSInteger col = j%2;
                j++;
                CGRect coverFrame = cover.frame;
                coverFrame.origin = CGPointMake(col * CGRectGetWidth(coverFrame),CGRectGetHeight(coverFrame)*row);
                cover.frame = coverFrame;
                [_containerView addSubview:cover];
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(exhibitionDB);
        
    }

}

#pragma mark - ShelfViewControllerProtocol implementation

-(void)coverSelected:(ThirdCoverView *)cover {
    NSString *selectedExhibitionID = cover.exhibitionID;
    Exhibition *selectedExhibition = [_exhibitionStore exhibitionWithID:selectedExhibitionID];
    if(!selectedExhibition) {
        NSLog(@"NO selected Exhibition id !!!!!!!");
        return;
    }
    [self openZip:selectedExhibition];

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
