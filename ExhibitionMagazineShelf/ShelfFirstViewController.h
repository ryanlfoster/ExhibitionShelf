//
//  ShelfFirstViewController.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-3-20.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "MBProgressHUD.h"
#import "CustomParentsViewController.h"

@class FirstCoverView;
@class ExhibitionStore;
@class Exhibition;

/*delegate protocol to click exhibition*/
@protocol ShelfFirstViewControllerClickExhibitionProtocol <NSObject>

-(void)clickExhibition:(FirstCoverView *)cover;

@end

/*delegate protocol to click exhibition which ready for download */
@protocol ShelfFirstViewControllerClickDownloadExhibitionProtocol <NSObject>

-(void)clickDownloadExhibition:(FirstCoverView *)cover;

@end

/*delegate protocol to click exhibition which cancel for download */
@protocol ShelfFirstViewControllerClickCancelDownloadExhibitionProtocol <NSObject>

-(void)clickCancelDownloadExhibition:(FirstCoverView *)cover;

@end

/*delegate protocol to click exhibition which cancel for download */
@protocol ShelfFirstViewControllerClickPlayExhibitionProtocol <NSObject>

-(void)clickPlayExhibition:(FirstCoverView *)cover;

@end

@interface ShelfFirstViewController : CustomParentsViewController<ShelfFirstViewControllerClickExhibitionProtocol,ShelfFirstViewControllerClickDownloadExhibitionProtocol,ShelfFirstViewControllerClickCancelDownloadExhibitionProtocol,ShelfFirstViewControllerClickPlayExhibitionProtocol,MBProgressHUDDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end
