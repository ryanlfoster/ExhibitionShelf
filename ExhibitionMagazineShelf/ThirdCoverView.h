//
//  ThirdCoverView.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-15.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "ShelfThirdViewController.h"
#import "BriefUILabel.h"

@interface ThirdCoverView : UIView

@property (nonatomic, copy) NSString *exhibitionID;
@property (nonatomic, strong) UIImageView *coverImageViewFrameView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) BriefUILabel *briefUILable;

@property (nonatomic, copy) NSString *exhibitionPath;

@property (nonatomic, weak) id <ShelfThirdViewControllerSelectedProtocol> delegatePlay;
@property (nonatomic, weak) id <ShelfThirdViewControllerDeletedProtocol> delegateDelete;

@end
