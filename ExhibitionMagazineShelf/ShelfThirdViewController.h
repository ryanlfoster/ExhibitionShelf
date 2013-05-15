//
//  ShelfThirdViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitionViewController.h"
#import "SqliteService.h"

@class ThirdCoverView;
@class ExhibitionStore;

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerSelectedProtocol
-(void)coverSelected:(ThirdCoverView *)cover;
@end

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerDeletedProtocol
-(void)coverDeleted:(ThirdCoverView *)cover;
@end

@interface ShelfThirdViewController : UIViewController<ShelfThirdViewControllerSelectedProtocol,ShelfThirdViewControllerDeletedProtocol,UIAlertViewDelegate>{
//------------------------------DataBase Property------------------------------------//
    sqlite3 *exhibitionDB;
}
//------------------------------View-------------------------------------------------//
@property (nonatomic, strong) ExhibitionStore *exhibitionStore;
@property (nonatomic, strong) UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) NSArray *listData;

@property (nonatomic, weak) UIView *alertViewThird;
@property (nonatomic, retain) NSString *alertString;

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
