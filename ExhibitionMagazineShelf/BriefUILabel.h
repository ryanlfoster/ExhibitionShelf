//
//  BriefUILabel.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-15.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BriefUILabel : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

-(void)changeGreen;
-(void)changeNormal;

@end
