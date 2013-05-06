//
//  ShelfSecondViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-20.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "MBProgressHUD.h"
@class SecondCoverView;
@class IssueStore;
/* delegate protocol to pass actions from the CoverView to the Shelf controller */
@protocol ShelfSecondViewControllerProtocol

-(void)coverSelected:(SecondCoverView *)cover;

@end

@interface ShelfSecondViewController : UIViewController<ShelfSecondViewControllerProtocol,MBProgressHUDDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>{
     NSURL *urlOfReadingIssue;
}

@property (strong, nonatomic) IBOutlet UIScrollView *containerView;

@property (strong, nonatomic) IssueStore *issueStore;

@property (strong, nonatomic) MBProgressHUD *progressHUD;

//load issueStore startup
-(void)resourceRequest;
@end
