//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShelfFirstViewController.h"
#import "SqliteService.h"
#define EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION @"ExhibitionEndOfDownload"
#define EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION @"ExhibitionFailedDownload"

@interface Exhibition : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *downloadData;//receive downloadData
    NSInteger expectedLength;//expect total downloadData
}

//-------------------------------Exhibition Property-----------------------------------//

//exhibition id(file name)
@property (nonatomic,copy)NSString *exhibitionID;

//exhibition title
@property (nonatomic,copy)NSString *title;

//exhibition cover net path 
@property (nonatomic,copy)NSString *coverURL;

//exhibition download net path
@property (nonatomic,copy)NSString *downloadURL;

//exhibition progress
@property (nonatomic,readonly) float downloadProgress;

//exhibition status download id
@property(nonatomic,readonly,getter = isDownloading) BOOL downloading;

//public method : exhibition file local path
-(NSURL *)contentURL;

@property (nonatomic,copy)NSString *image;
//public method : exhibition cover local path
-(NSString *)exhibitionImagePath;
@property (nonatomic,copy)NSString *file;
//public method : exhibition dir local path
-(NSString *)exhibitionFilePath;

//exhibition downloaded return boolean read or open
-(BOOL)isExhibitionAvailibleForRead;

@end
