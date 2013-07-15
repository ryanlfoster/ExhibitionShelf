//
//  ShelfFirstViewController.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ExhibitionViewController.h"
#import "CustomPageControl.h"
#import "CustomParentsViewController.h"

@class FirstCoverView;
@class ExhibitionStore;
@class Exhibition;
/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfFirstViewControllerProtocol
-(void)coverSelected:(FirstCoverView *)cover;
@end

@interface ShelfFirstViewController : CustomParentsViewController<ShelfFirstViewControllerProtocol,MBProgressHUDDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    NSOperationQueue *_queue;
    Exhibition *receiveExhibition;
}
@property (strong, nonatomic) UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (strong, nonatomic) ExhibitionStore *exhibitionStore;
@property (strong, nonatomic) MBProgressHUD *progressHUD;//开启应用的加载等待view

-(void)updateShelf;

@end
