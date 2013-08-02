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
#import "CustomPageControl.h"

@interface ShelfShareViewController (){
    NSUInteger numberOfPages;
}

@property (nonatomic, strong) UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (nonatomic, strong) NSArray *listData;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) CGPoint point;

-(void)loadScrollViewData;
-(void)slide;

@end

@implementation ShelfShareViewController
@synthesize containerView = _containerView;
@synthesize pageControl = _pageControl;
@synthesize listData = _listData;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize point = _point;

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
    
    _leftButton.alpha = 0.0f;
    _rightButton.alpha = 0.0f;
    
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
    
    if(numberOfPages == 1){
        _rightButton.alpha = 0.0f;
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
    
    //scroll view
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _containerView.pagingEnabled = YES;
    _containerView.contentSize = CGSizeMake(_containerView.frame.size.width * numberOfPages, 0);
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];
    
    //page view
    _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"image_page_state_normal.png"]];
    [_pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"image_page_state_highly.png"]];
    _pageControl.numberOfPages = numberOfPages;
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = NO;
    [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_pageControl];
    
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
    
    UITapGestureRecognizer *clickGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slide)];
    clickGestureRecognizer.delegate = self;
    [_containerView addGestureRecognizer:clickGestureRecognizer];
    
}

 /**
  *	slide
  */
-(void)slide
{
    NSLog(@"slide !!!");
    int x = _point.x;
    int y = _point.y;
    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    
    CGFloat pageWidth = _containerView.frame.size.width;
    int page = floor((_containerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(CGRectContainsPoint(CGRectMake(page * 1024, 220, 100, 100), _point)){
        NSLog(@"turn left");
        if(_leftButton.alpha == 1.0f){
            [_containerView setContentOffset:CGPointMake(1024.0f * (page - 1), 0.0f) animated:YES];
        }
        
    }else if (CGRectContainsPoint(CGRectMake(page * 1024 + 950, 220, 100, 100),_point)){
        NSLog(@"turn right");
        if(_rightButton.alpha == 1.0f){
            [_containerView setContentOffset:CGPointMake(1024.0f * (page + 1), 0.0f) animated:YES];
        }
    }
}

#pragma mark -UIScrollViewDelegate
/**
 *	scrollView delegate
 *
 *	@param	scrollView	crollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _containerView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    NSArray *subView = _pageControl.subviews;
    for(int i = 0; i < [subView count]; i++){
        UIImageView *dot = [subView objectAtIndex:i];
        dot.image = (_pageControl.currentPage == i ? [UIImage imageNamed:@"image_page_state_highly.png"] : [UIImage imageNamed:@"image_page_state_normal.png"]);
    }
    
    if (_pageControl.currentPage == 0) {
        _leftButton.alpha = 0.0f;
        if(numberOfPages > 1){
            _rightButton.alpha = 1.0f;
        }
    }else if(_pageControl.currentPage == [subView count] - 1){
        _rightButton.alpha = 0.0f;
        _leftButton.alpha = 1.0f;
    }
}

#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if([view isKindOfClass:[UIScrollView class]]){
        _point = [touch locationInView:[touch view]];
        return YES;
    }
    return NO;
}

-(void)viewDidUnload {
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
@end
