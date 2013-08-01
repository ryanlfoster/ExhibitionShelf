//
//  Exhibition.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-3-29.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

@interface Exhibition : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, copy)NSString *exhibitionID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *coverURL;
@property (nonatomic, copy)NSString *downloadURL;
@property (nonatomic, copy)NSString *description;

-(NSURL *)contentURL;
-(BOOL)isExhibitionAvailibleForPlay;
-(NSString *)exhibitionImagePath;
-(NSString *)exhibitionFilePath;
-(void)stopDownload;
-(void)sendEndOfDownloadNotification;
-(void)sendFailedDownloadNotification;
+(BOOL)isDownlaoding;

@end
