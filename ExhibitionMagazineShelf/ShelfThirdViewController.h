//
//  ShelfThirdViewController.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitionViewController.h"
#import "SqliteService.h"
#import "ShelfFirstViewController.h"
#import "CustomParentsViewController.h"

@class ThirdCoverView;

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerSelectedProtocol
-(void)coverSelected:(ThirdCoverView *)cover;
@end

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerDeletedProtocol
-(void)coverDeleted:(ThirdCoverView *)cover;
@end

@interface ShelfThirdViewController : CustomParentsViewController<ShelfThirdViewControllerSelectedProtocol,ShelfThirdViewControllerDeletedProtocol,UIAlertViewDelegate,UIScrollViewDelegate>{
//------------------------------DataBase Property------------------------------------//
    sqlite3 *exhibitionDB;
}
//------------------------------View-------------------------------------------------//
@property (nonatomic, strong) UIScrollView *containerView;
@property (strong, nonatomic) UIButton *aboutusButton;
@property (nonatomic, retain) NSArray *listData;

@property (nonatomic, weak) UIView *alertViewThird;
@property (nonatomic, retain) NSString *alertString;

@property (nonatomic,retain) ShelfFirstViewController *shelfFirstViewController;

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
