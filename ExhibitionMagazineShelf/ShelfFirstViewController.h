//
//  ShelfFirstViewController.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CustomParentsViewController.h"

@class FirstCoverView;
@class ExhibitionStore;
@class Exhibition;
@class ShelfThirdViewController;
/* delegate protocol to pass actions from the CoverView to the Shelf controller */
//@protocol ShelfFirstViewControllerProtocol
//-(void)coverSelected:(FirstCoverView *)cover;
//@end

/*delegate protocol to click exhibition*/
@protocol ShelfFirstViewControllerClickExhibitionProtocol <NSObject>

-(void)clickExhibition:(FirstCoverView *)cover;

@end

/*delegate protocol to click exhibition which ready for download */
@protocol ShelfFirstViewControllerClickDownloadExhibitionProtocol <NSObject>

-(void)clickDownloadExhibition:(FirstCoverView *)cover;

@end

@interface ShelfFirstViewController : CustomParentsViewController<ShelfFirstViewControllerClickExhibitionProtocol,ShelfFirstViewControllerClickDownloadExhibitionProtocol,MBProgressHUDDelegate,UIScrollViewDelegate>{
    
    CALayer *transitionLayer;
    
}

@property (strong, nonatomic) ExhibitionStore *exhibitionStore;
@property (strong, nonatomic) ShelfThirdViewController *stvc;

@end
