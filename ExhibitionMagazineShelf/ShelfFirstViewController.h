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
#import <sqlite3.h>
@class FirstCoverView;
@class ExhibitionStore;

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfFirstViewControllerProtocol
-(void)coverSelected:(FirstCoverView *)cover;
@end

@interface ShelfFirstViewController : UIViewController<ShelfFirstViewControllerProtocol,MBProgressHUDDelegate>{
    
//------------------------------DataBase Property------------------------------------//
    sqlite3 *exhibitionDB;

}
@property (strong, nonatomic) IBOutlet UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong,nonatomic) ExhibitionStore *exhibitionStore;
@property (strong,nonatomic) MBProgressHUD *progressHUD;

//------------------------------DataBase Property------------------------------------//
@property (retain,nonatomic)NSString *databasePath;

@end
