//
//  FirstCoverView.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-3.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfFirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MCProgressBar.h"

@interface FirstCoverView : UIView
@property (nonatomic,copy) NSString *exhibitionID;
@property (nonatomic,assign) id<ShelfFirstViewControllerProtocol> delegate;
@property (nonatomic,strong) UIImageView *cover;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) MCProgressBar *progress;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *description;
@end
