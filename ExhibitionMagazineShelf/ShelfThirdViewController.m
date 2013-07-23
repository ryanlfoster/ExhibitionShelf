//
//  ShelfThirdViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfThirdViewController.h"
#import "ThirdCoverView.h"
#import "Exhibition.h"

NSUInteger numberOfPages;//scrollView page count

@interface ShelfThirdViewController()

@end

@implementation ShelfThirdViewController
@synthesize containerView = _containerView;
@synthesize listData = _listData;

@synthesize alertString = _alertString;
@synthesize alertViewThird = _alertViewThird;

#pragma mark -init nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -View lifecycle
- (void)viewDidLoad    //Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
{
    [super viewDidLoad];
    
    /***********************************background****************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"exhibitiondisplay_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
    /************************************************************************************/
    
}

-(void)viewWillAppear:(BOOL)animated
{
    SqliteService *sqliteService = [[SqliteService alloc] init];
    _listData = [sqliteService getAllDateFromTable];
    if([_listData count] % 6 == 0){
        numberOfPages = [_listData count] / 6;
    }else{
        numberOfPages = 1 + ([_listData count] / 6);
    }
    
    [self loadScrollViewData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

/**********************************************************
 函数名称：-(void)addExhibition:(NSNotification *)notification
 函数描述：更新ThirdView
 输入参数：(NSNotification *)notification
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)addExhibition
{
    [self viewWillAppear:YES];
}

/**********************************************************
 函数名称：-(void)loadScrollViewData
 函数描述：更新scrollView295435247
 输入参数：N/A
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)loadScrollViewData
{
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 670)];
    _containerView.pagingEnabled = YES;
    _containerView.contentSize = CGSizeMake(_containerView.frame.size.width * numberOfPages, 0);
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];

    //load content in scrollView
    for(int i = 0 ; i < [_listData count] ; i++){
        ThirdCoverView *cover = [[ThirdCoverView alloc] initWithFrame:CGRectZero];
        Exhibition *exhibition = [_listData objectAtIndex:i];
        cover.exhibitionID = exhibition.exhibitionID;
        
        CGFloat edge;
        if(i >= 6 ){
            edge = 70.0f;
        }else edge = 0;
        CGFloat row = i / 2;
        CGFloat col = i % 2;
        CGRect coverFrame = cover.frame;
        coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * row + 96.0f * row + edge * (i / 6), CGRectGetHeight(coverFrame) * col + col * 36.0f);
        cover.frame = coverFrame;
        cover.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:cover];
    }
}

#pragma mark -ShelfThirdViewControllerSelectedProtocol implementation
/**********************************************************
 函数名称：-(void)coverSelected:(ThirdCoverView *)cover
 函数描述：ShelfThirdViewControllerSelectedProtocol
 输入参数：(ThirdCoverView *)cover：view
 输出参数：N/A
 返回值：void
 **********************************************************/
//-(void)coverSelected:(ThirdCoverView *)cover {
//    
//    NSLog(@"Selected !!!");
//    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
//    NSBundle *myBundle = [NSBundle bundleWithPath:cover.file];
//    NSLog(@"myBundle = %@",myBundle);
//    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
//    viewController.navigationBarTitle = cover.title.text;
//    //turn view
//    if(viewController.str != nil){
//        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        [self presentModalViewController:viewController animated:YES];
//    }
//    
//}

#pragma mark -ShelfThirdViewControllerDeletedProtocol implementation
/**********************************************************
 函数名称：-(void)coverSelected:(ThirdCoverView *)cover
 函数描述：ShelfThirdViewControllerDeletedProtocol
 输入参数：(ThirdCoverView *)cover：view
 输出参数：N/A
 返回值：void
 **********************************************************/
-(void)coverDeleted:(ThirdCoverView *)cover
{
    NSLog(@"删除中 ＝＝ %d",[Exhibition ifHaveExhibitionDownloading]);
    if ([Exhibition ifHaveExhibitionDownloading]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有全景展览正在下载，请您稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真的要删除此展览?" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回", nil];
        [alert show];
    }
    
    //variable control UIAlertViewDelegate
    _alertViewThird = cover;
    _alertString = cover.exhibitionID;
    
}

#pragma mark -UIAlertViewDelegate
/**********************************************************
 函数名称：-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 函数描述：UIAlertViewDelegate
 输入参数：(UIAlertView *)alertView:alertView clickedButtonAtIndex:(NSInteger)buttonIndex:button
 输出参数：N/A
 返回值：void
 **********************************************************/
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
    
    [self viewWillAppear:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
