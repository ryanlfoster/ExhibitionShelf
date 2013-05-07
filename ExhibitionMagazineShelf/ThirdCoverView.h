//
//  ThirdCoverView.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ShelfThirdViewController.h"
@interface ThirdCoverView : UIView
@property (nonatomic,copy) NSString *exhibitionID;
@property (nonatomic,assign) id<ShelfThirdViewControllerSelectedProtocol> delegateSelected;
@property (nonatomic,assign) id<ShelfThirdViewControllerDeletedProtocol> delegateDeleted;
@property (nonatomic,strong) UIImageView *cover;
@property (nonatomic,strong) UIButton *viewButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UILabel *title;
@end
