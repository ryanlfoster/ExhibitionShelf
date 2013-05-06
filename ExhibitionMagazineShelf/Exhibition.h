//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ShelfFirstViewController.h"
#define EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION @"ExhibitionEndOfDownload"
#define EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION @"ExhibitionFailedDownload"

@interface Exhibition : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *downloadData;//receive downloadData
    NSInteger expectedLength;//expect total downloadData

//------------------------------DataBase Property--------------------------------------//
    sqlite3 *exhibitionDB;
    
    NSString *dbTitle;
    NSString *dbPathCoverImg;
    NSString *dbPathFile;
}

//-------------------------------DataBase Property-------------------------------------//
@property (retain,nonatomic)NSString *databasePath;

//-------------------------------Exhibition Property-----------------------------------//

//exhibition id
@property (nonatomic,copy)NSString *exhibitionID;

//exhibition title
@property (nonatomic,copy)NSString *title;

//exhibition cover path
@property (nonatomic,copy)NSString *coverURL;

//exhibition download path
@property (nonatomic,copy)NSString *downloadURL;

//exhibition progress
@property (nonatomic,readonly) float downloadProgress;

//exhibition status download id
@property(nonatomic,readonly,getter = isDownloading) BOOL downloading;

//exhibition downloaded path
-(NSURL *)contentURL;

//exhibition cover image path
-(UIImage *)coverImage;

//exhibition downloaded return boolean read or open
-(BOOL)isExhibitionAvailibleForRead;

@end
