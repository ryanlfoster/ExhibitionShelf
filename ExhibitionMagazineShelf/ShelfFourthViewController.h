//
//  ShelfFourthViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-4-11.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ShelfFourthViewController : UIViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic)MBProgressHUD *progressHUD;

@end
