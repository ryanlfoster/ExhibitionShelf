//
//  ShelfThirdViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitionViewController.h"
#import <sqlite3.h>
@class ThirdCoverView;
@class ExhibitionStore;

/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfThirdViewControllerProtocol
-(void)coverSelected:(ThirdCoverView *)cover;
@end

@interface ShelfThirdViewController : UIViewController<ShelfThirdViewControllerProtocol>{
//------------------------------DataBase Property------------------------------------//
    sqlite3 *exhibitionDB;
//------------------------------store exhibition downloaded--------------------------//
//    NSMutableArray *exhibitionDownloadedArray;
}
//------------------------------View-------------------------------------------------//
@property(nonatomic,strong)ExhibitionStore *exhibitionStore;
@property (strong, nonatomic) IBOutlet UIScrollView *containerView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

//------------------------------DataBase Property------------------------------------//
@property (retain,nonatomic)NSString *databasePath;

@end
