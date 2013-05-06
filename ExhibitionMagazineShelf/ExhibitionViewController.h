//
//  ExhibitionViewController.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionViewController : UIViewController<UIWebViewDelegate>
{
    @private
    UIWebView *webView;
    UINavigationBar *navigationBar;
}
@property (nonatomic,weak)NSString *str;
@property (nonatomic,weak)NSString *navigationBarTitle;

@end
