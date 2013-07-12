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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end
