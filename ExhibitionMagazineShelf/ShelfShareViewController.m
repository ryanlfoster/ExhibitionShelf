//
//  ShelfShareViewController.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-31.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "ShareView.h"
#import "SqliteService.h"
#import "ShelfShareViewController.h"

@interface ShelfShareViewController (){
    NSUInteger numberOfPages;
}

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) NSArray *listData;

-(void)loadScrollViewData;

@end

@implementation ShelfShareViewController
@synthesize containerView = _containerView;
@synthesize listData = _listData;

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
	// Do any additional setup after loading the view.
    /***********************************background***************************************/
    //load background
    UIImage *backgroundImage = [UIImage imageNamed:@"exhibitiondisplay_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.view.backgroundColor = backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    SqliteService *sqliteService = [[SqliteService alloc] init];
    _listData = [sqliteService getAllDateFromTable];
    
    NSLog(@"_listData count == %d",[_listData count]);
    
    if([_listData count] % 3 == 0){
        numberOfPages = [_listData count] / 3;
    }else{
        numberOfPages = 1 + ([_listData count] / 3);
    }
    
    [self loadScrollViewData];
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
    
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    _containerView.pagingEnabled = YES;
    _containerView.contentSize = CGSizeMake(_containerView.frame.size.width * numberOfPages, 0);
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];
    
    //load content in scrollView
    for(int i = 0 ; i < [_listData count] ; i++){
        ShareView *cover = [[ShareView alloc] initWithFrame:CGRectZero];
        Exhibition *anExhibition = [_listData objectAtIndex:i];
        
        cover.coverImageView.image = [UIImage imageWithContentsOfFile:[anExhibition exhibitionImagePath]];
        cover.briefLabel.titleLabel.text = anExhibition.title;
        cover.briefLabel.subTitleLabel.text = anExhibition.subTitle;
        cover.briefLabel.dateLabel.text = anExhibition.date;
        
        CGFloat edge = 0.0f;
        if (i >= 3) {
            edge = 89.5f;
        }
        
        CGRect coverFrame = cover.frame;
        coverFrame.origin = CGPointMake(CGRectGetWidth(coverFrame) * i + 89.5f * i + edge * (i / 3), 0);
        cover.frame = coverFrame;
        cover.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:cover];
    }
    
}

@end
