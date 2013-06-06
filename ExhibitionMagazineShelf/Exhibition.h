//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteService.h"
#import "ShelfThirdViewController.h"

@interface Exhibition : NSObject<NSURLConnectionDataDelegate>

//exhibition id(file name)
@property (nonatomic, copy)NSString *exhibitionID;
//exhibition title
@property (nonatomic, copy)NSString *title;
//exhibition cover net path 
@property (nonatomic, copy)NSString *coverURL;
//exhibition download net path
@property (nonatomic, copy)NSString *downloadURL;
//exhibition description
@property (nonatomic, copy)NSString *description;
//exhibition progress
@property (nonatomic, readonly) float downloadProgress;

//exhibition receive downloadData
@property (nonatomic, copy)NSMutableData *downloadData;
//progress expected length
@property (nonatomic, assign)NSInteger expectedLength;
//progress receive total number
@property (nonatomic, retain)NSNumber *expectedLengthNumber;
@property (nonatomic, retain)NSNumber *downloadDataLengthNumber;
//exhibition status download id
@property (nonatomic,readwrite,getter = isDownloading) BOOL downloading;

@property (nonatomic,copy)NSString *file;
@property (nonatomic,copy)NSString *image;

//exhibition file local path
-(NSURL *)contentURL;
//exhibition downloaded return boolean read or open
-(BOOL)isExhibitionAvailibleForRead;
-(NSString *)exhibitionImagePath;
-(NSString *)exhibitionFilePath;
//exhibition downloading
-(BOOL)isDownloading;

+(BOOL)ifHaveExhibitionDownloading;

@end
