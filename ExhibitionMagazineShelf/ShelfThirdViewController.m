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
#import "ExhibitionViewController.h"

NSUInteger numberOfPages;

@interface ShelfThirdViewController()

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, weak) UIView *alertViewThird;
@property (nonatomic, copy) NSString *alertString;
@property (nonatomic, strong) PlaySoundTools *sound;

-(void)loadScrollViewData;

@end

@implementation ShelfThirdViewController
@synthesize containerView = _containerView;
@synthesize listData = _listData;
@synthesize alertString = _alertString;
@synthesize alertViewThird = _alertViewThird;
@synthesize sound = _sound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

/**
 *	Called after the view has been loaded. For view controllers created in code, this is after -loadView. 
    For view controllers unarchived from a nib, this is after the view is set.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /***********************************background***************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"exhibitiondisplay_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;

}

-(void)viewWillAppear:(BOOL)animated
{
    SqliteService *sqliteService = [[SqliteService alloc] init];
    _listData = [sqliteService getAllDateFromTable];
    
    NSLog(@"_listData count == %d",[_listData count]);
    
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

#pragma mark -Public Methods
/**
 *	add exhibition in Third View
 *
 *	@param	addExhibition	exhibiton which tansmit downloaded
 */
-(void)addExhibition:(Exhibition *)addExhibition
{
    [self viewWillAppear:YES];
    
    SqliteService *sqlService = [[SqliteService alloc] init];
    if ([sqlService insertToDB:addExhibition]) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"download_complete" ofType: @"wav"];
        _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
        [_sound play];
        [addExhibition sendEndOfDownloadNotification];
    }else{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"将对象插入到本地库失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:addExhibition.coverURL]];
        if(imgData) {
            //save img to sand box
            [imgData writeToFile:[addExhibition exhibitionImagePath] atomically:YES];
        }
    });
}


#pragma mark -Private Methods
/**
 *	load exhibition which have downloaded in scrollView
 */
-(void)loadScrollViewData
{
    if(_containerView != nil){
        [_containerView removeFromSuperview];
    }
    
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 266 * 2 + 36)];
    _containerView.pagingEnabled = YES;
    _containerView.contentSize = CGSizeMake(_containerView.frame.size.width * numberOfPages, 0);
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];

    //load content in scrollView
    dispatch_async(dispatch_get_main_queue(), ^{
        for(int i = 0 ; i < [_listData count] ; i++){
            ThirdCoverView *cover = [[ThirdCoverView alloc] initWithFrame:CGRectZero];
            Exhibition *anExhibition = [_listData objectAtIndex:i];
            cover.exhibitionID = anExhibition.exhibitionID;
            cover.coverImageView.image = [UIImage imageWithContentsOfFile:[anExhibition exhibitionImagePath]];
    
            cover.briefUILable.titleLabel.text = anExhibition.title;
            cover.briefUILable.subTitleLabel.text = anExhibition.subTitle;
            cover.briefUILable.dateLabel.text = anExhibition.date;
            [cover.briefUILable changeGreen];
            
            cover.exhibitionPath = [anExhibition exhibitionFilePath];
            
            cover.delegatePlay = self;
            cover.delegateDelete = self;
            
            CGFloat edge;
            CGFloat row = i % 3;
            CGFloat col = 0.0;
            
            if (((i / 3) % 2) == 1) {
                col = 1;
            }else col = 0;
            
            if(i >= 6 ){
                edge = 1024.0f;
            }else edge = 0;
            
            CGRect coverFrame = cover.frame;
            coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * row + 96.0f * row + edge * (i / 6), CGRectGetHeight(coverFrame) * col + col * 36.0f);
            cover.frame = coverFrame;
            cover.backgroundColor = [UIColor clearColor];
            [_containerView addSubview:cover];        }
    });
}

#pragma mark -ShelfThirdViewControllerSelectedProtocol implementation
/**
 *	click exhibiiton which cover play imageView
 *
 *	@param	cover	ThirdCoverView
 */
-(void)coverSelected:(ThirdCoverView *)cover
{
    ExhibitionViewController *viewController = [[ExhibitionViewController alloc] init];
    NSBundle *myBundle = [NSBundle bundleWithPath:cover.exhibitionPath];
    viewController.str = [myBundle pathForResource:@"index" ofType:@"html"];
    viewController.navigationBarTitle = cover.briefUILable.titleLabel.text;
    //turn view
    if(viewController.str != nil){
        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:viewController animated:YES];
    }
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"applaunch" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
}

#pragma mark -ShelfThirdViewControllerDeletedProtocol implementation
/**
 *	click to delete exhibition
 *
 *	@param	cover	ThirdCoverView
 */
-(void)coverDeleted:(ThirdCoverView *)cover
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真的要删除此展览?" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"返回", nil];
    [alert show];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"alert" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
    
    _alertViewThird = cover;
    _alertString = cover.exhibitionID;
    
}

#pragma mark -UIAlertViewDelegate
/**
 *	alert view
 *
 *	@param	alertView	delete exhibition view
 *	@param	buttonIndex	0:YES 1 :return 
 */
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
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"app_delete" ofType: @"wav"];
        _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
        [_sound play];

    }else return;
    
    [self viewWillAppear:YES];
}

@end
