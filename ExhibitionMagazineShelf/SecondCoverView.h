//
//  CoverView.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-22.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfSecondViewController.h"
@interface SecondCoverView : UIView
@property (nonatomic,copy) NSString *issueID;
@property (nonatomic,assign) id<ShelfSecondViewControllerProtocol> delegate;
@property (nonatomic,strong) UIImageView *cover;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIProgressView *progress;
@property (nonatomic,strong) UILabel *title;
@end
