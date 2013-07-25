//
//  ExhibitionViewController.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, copy)NSString *str;
@property (nonatomic, copy)NSString *navigationBarTitle;
@property (nonatomic, strong)UIButton *backButton;
@property (nonatomic, strong)UINavigationBar *navigationBar;
@property (nonatomic, strong)UIWebView *webView;

@end
