//
//  ShelfThirdViewController.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-4-11.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "ExhibitionViewController.h"
#import "CustomParentsViewController.h"

@class ThirdCoverView;
@class Exhibition;
/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerSelectedProtocol
-(void)coverSelected:(ThirdCoverView *)cover;
@end

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerDeletedProtocol
-(void)coverDeleted:(ThirdCoverView *)cover;
@end

@interface ShelfThirdViewController : CustomParentsViewController<ShelfThirdViewControllerSelectedProtocol,ShelfThirdViewControllerDeletedProtocol,UIAlertViewDelegate,UIScrollViewDelegate>

-(void)addExhibition:(Exhibition *)addExhibition;

@end
