//
//  CoverImageView.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-12.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverImageView : UIImageView<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *exhibitionID;

@end
