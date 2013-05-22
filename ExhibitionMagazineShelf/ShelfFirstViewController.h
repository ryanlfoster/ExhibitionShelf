//
//  ShelfFirstViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ExhibitionViewController.h"
#import "CustomPageControl.h"
@class FirstCoverView;
@class ExhibitionStore;

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfFirstViewControllerProtocol
-(void)coverSelected:(FirstCoverView *)cover;
@end

@interface ShelfFirstViewController : UIViewController<ShelfFirstViewControllerProtocol,MBProgressHUDDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UIScrollView *containerView;

@property (strong, nonatomic) CustomPageControl *pageControl;

@property (strong, nonatomic) ExhibitionStore *exhibitionStore;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic, retain) NSArray *listData;

-(void)resourceRequest;

@end
