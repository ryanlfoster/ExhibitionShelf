//
//  ThirdCoverView.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ShelfThirdViewController.h"
#import "BriefUILabel.h"
#import "MCProgressBar.h"

@interface ThirdCoverView : UIView

@property (nonatomic, copy) NSString *exhibitionID;
@property (nonatomic, strong)UIImageView *coverImageViewFrameView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *coverImageViewDownloading;
@property (nonatomic, strong) UIImageView *coverImageViewReadyPlay;
@property (nonatomic, strong) BriefUILabel *briefUILable;
@property (nonatomic, strong) MCProgressBar *progressBar;

@end
