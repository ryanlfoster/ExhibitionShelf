//
//  ShelfSecondViewController.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ShelfSecondViewController.h"
#import "IssueStore.h"
#import "SecondCoverView.h"
#import "Issue.h"
#import <QuickLook/QuickLook.h>

@interface ShelfSecondViewController ()
-(void)showShelf;
-(void)readIssue:(Issue *)issue;
-(void)downloadIssue:(Issue *)issue updateCover:(SecondCoverView *)cover;
-(SecondCoverView *)coverWithID:(NSString *)issueID;
@end

@implementation ShelfSecondViewController
@synthesize containerView = _containerView;
@synthesize issueStore = _issueStore;
@synthesize progressHUD = _progressHUD;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load progressHUD
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    self.progressHUD.labelText = @"loading";
    [_progressHUD show:YES];
    
    //NSThread
    [NSThread detachNewThreadSelector:@selector(resourceRequest) toTarget:self withObject:nil];

}

- (void)viewDidUnload
{
    [self setContainerView:nil];
    [self setContainerView:nil];
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

-(void)resourceRequest
{
    //init Issue;
    _issueStore = [[IssueStore alloc] init];
    [_issueStore startup];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChangeStatusNotification:)
                                                 name:STORE_CHANGED_STATUS_NOTIFICATION
                                               object:nil];
    
    NSLog(@"Store status: %d",_issueStore.status);
}

#pragma mark - View display
-(void)storeDidChangeStatusNotification:(NSNotification *)not {
    NSLog(@"Store changed status to %d",_issueStore.status);
//    [self updateShelf];
    [self showShelf];
    
}

-(void)showShelf {
    if([_issueStore isStoreReady]) {
        _containerView.contentSize = CGSizeMake(0,1024);
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.alpha=1.0;
        
        //back main thread
        [self performSelectorOnMainThread:@selector(updateShelf) withObject:_containerView waitUntilDone:NO];
    } else {
        _containerView.alpha=0.0;
    }
    
}

-(void)updateShelf {
    // 更新书架
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat deltaX = (screenSize.width/3.);
    CGFloat deltaY = (screenSize.height/3.);
    NSInteger issuesCount = [_issueStore numberOfStoreIssues];
    for(NSInteger i=0;i<issuesCount;i++) {
        Issue *anIssue = [_issueStore issueAtIndex:i];
        SecondCoverView *cover = [[SecondCoverView alloc] initWithFrame:CGRectZero];
        cover.issueID=anIssue.issueID;
        cover.delegate=self;
        cover.title.text=anIssue.title;
        cover.cover.image=[anIssue coverImage];
        if([anIssue isIssueAvailibleForRead]) {
            [cover.button setTitle:@"READ" forState:UIControlStateNormal];
        } else {
            [cover.button setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
        }
        NSInteger row = i/4;
        NSInteger col = i%4;
        CGRect coverFrame = cover.frame;
        coverFrame.origin=CGPointMake(30+deltaX*col+(deltaX-CGRectGetWidth(coverFrame))/2.0, 40+deltaY*row+(deltaY-CGRectGetHeight(coverFrame))/2.0);
        cover.frame=coverFrame;
        [_containerView addSubview:cover];
        
        if(_progressHUD){
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }
    }
    
}

-(SecondCoverView *)coverWithID:(NSString *)issueID {
    for(UIView *aView in _containerView.subviews) {
        if([aView isKindOfClass:[SecondCoverView class]] && [[(SecondCoverView *)aView issueID] isEqualToString:issueID]) {
            return (SecondCoverView *)aView;
        }
    }
    return nil;
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

#pragma mark - ShelfViewControllerProtocol implementation

-(void)coverSelected:(SecondCoverView *)cover {
    NSString *selectedIssueID = cover.issueID;
    Issue *selectedIssue = [_issueStore issueWithID:selectedIssueID];
    if(!selectedIssue) return;
    if([selectedIssue isIssueAvailibleForRead]) {
        [self readIssue:selectedIssue];
    } else {
        [self downloadIssue:selectedIssue updateCover:cover];
    }
}

#pragma mark - Actions

-(void)readIssue:(Issue *)issue {
    NSLog(@"%@",[issue issueID]);
    QLPreviewController *preview = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
    preview.delegate=self;
    preview.dataSource=self;
    urlOfReadingIssue=[[issue contentURL] URLByAppendingPathComponent:@"magazine.pdf"];
    [self presentModalViewController:preview animated:YES];
}

-(void)downloadIssue:(Issue *)issue updateCover:(SecondCoverView *)cover {
    cover.progress.alpha=1.0;
    cover.button.alpha=0.0;

    [issue addObserver:cover forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueDidEndDownload:) name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:issue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueDidFailDownload:) name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:issue];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(issueDidEndDownload:) name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:issue];
    [[NSNotificationCenter defaultCenter] addObserver:cover selector:@selector(issueDidFailDownload:) name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:issue];
    [_issueStore scheduleDownloadOfIssue:issue];
}

-(void)issueDidEndDownload:(NSNotification *)notification {
    Issue *issue = (Issue *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:issue];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:issue];
}

-(void)issueDidFailDownload:(NSNotification *)notification {
    Issue *issue = (Issue *)[notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:issue];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:issue];
}

#pragma mark QuickLook

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return urlOfReadingIssue;
}



@end
