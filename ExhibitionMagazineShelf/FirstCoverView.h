//
//  FirstCoverView.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-3.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfFirstViewController.h"
#import "MCProgressBar.h"
#import "CoverImageView.h"
#import "BriefUILabel.h"
#import "DownloadImageView.h"

@interface FirstCoverView : UIView

//@property (nonatomic,copy) NSString *exhibitionID;
//@property (nonatomic,assign) id<ShelfFirstViewControllerProtocol> delegate;
//@property (nonatomic,strong) UIImageView *cover;
//@property (nonatomic,strong) UIButton *button;
//@property (nonatomic,strong) UILabel *title;
//@property (nonatomic,strong) UILabel *description;
//@property (nonatomic,strong) MCProgressBar *progressBar;

@property (nonatomic, copy) NSString *exhibitionID;
@property (nonatomic, strong) UIImageView *coverImageViewFrameView;
@property (nonatomic, strong) CoverImageView *coverImageView;
@property (nonatomic, strong) DownloadImageView *downloadImageView;
@property (nonatomic, strong) BriefUILabel *briefUILable;

@property (nonatomic, weak) id<ShelfFirstViewControllerClickExhibitionProtocol> delegate;
@property (nonatomic, weak) id<ShelfFirstViewControllerClickDownloadExhibitionProtocol>delegateCancelDownload;

@end
