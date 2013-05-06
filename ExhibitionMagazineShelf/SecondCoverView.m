//
//  CoverView.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-22.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "SecondCoverView.h"
#import "Issue.h"
@implementation SecondCoverView
@synthesize issueID = _issueID;
@synthesize cover = _cover;
@synthesize button = _button;
@synthesize progress = _progress;
@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 256, 384);
        // title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _title.font=[UIFont boldSystemFontOfSize:18];
        _title.textColor=[UIColor whiteColor];
        _title.backgroundColor=[UIColor clearColor];
        _title.textAlignment=UITextAlignmentCenter;
        // cover image
        self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 200, 200)];
        _cover.backgroundColor=[UIColor clearColor];
        _cover.contentMode=UIViewContentModeScaleAspectFit;
        // progress
        self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 226, 200, 20)];
        _progress.alpha=0.0;
        _progress.progressViewStyle=UIProgressViewStyleBar;
        // button
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"bottone_leggi"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonCallback:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
        _button.frame=CGRectMake(5, 226, 200, 21);
        
        [self addSubview:_title];
        [self addSubview:_cover];
        [self addSubview:_progress];
        [self addSubview:_button];
        
    }
    return self;
}

#pragma mark - Callbacks

-(void)buttonCallback:(id)sender {

    [_delegate coverSelected:self];
}

#pragma mark - KVO and Notifications

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    _progress.progress=value;
}

-(void)issueDidEndDownload:(NSNotification *)notification {
    id obj = [notification object];
    _progress.alpha=0.0;
    [_button setTitle:@"READ" forState:UIControlStateNormal];
    _button.alpha=1.0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:obj];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:obj];
    [obj removeObserver:self forKeyPath:@"downloadProgress"];
}

-(void)issueDidFailDownload:(NSNotification *)notification {
    id obj = [notification object];
    _progress.alpha=0.0;
    [_button setTitle:@"READ" forState:UIControlStateNormal];
    _button.alpha=1.0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:obj];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:obj];
    [obj removeObserver:self forKeyPath:@"downloadProgress"];
}


@end
