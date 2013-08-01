//
//  FirstCoverView.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-3.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfFirstViewController.h"
#import "MCProgressBar.h"
#import "CoverImageView.h"
#import "BriefUILabel.h"
#import "DownloadImageView.h"

@interface FirstCoverView : UIView{
        CALayer *transitionLayer;
}

@property (nonatomic, copy) NSString *exhibitionID;
@property (nonatomic, strong) UIImageView *coverImageViewFrameView;
@property (nonatomic, strong) CoverImageView *coverImageView;
@property (nonatomic, strong) DownloadImageView *downloadImageView;
@property (nonatomic, strong) UIImageView *downloadingImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) BriefUILabel *briefUILable;
@property (nonatomic, strong) BriefUILabel *changeLocationBriefUILable;
@property (nonatomic, strong) MCProgressBar *progressBar;

@property (nonatomic, weak) id<ShelfFirstViewControllerClickExhibitionProtocol> delegate;
@property (nonatomic, weak) id<ShelfFirstViewControllerClickDownloadExhibitionProtocol>delegateDownload;
@property (nonatomic, weak) id<ShelfFirstViewControllerClickCancelDownloadExhibitionProtocol>delegateCancelDownload;
@property (nonatomic, weak) id<ShelfFirstViewControllerClickPlayExhibitionProtocol>delegatePlay;

@end
