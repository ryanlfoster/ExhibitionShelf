//
//  Issue.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-21.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ISSUE_END_OF_DOWNLOAD_NOTIFICATION @"IssueEndOfDownload"
#define ISSUE_FAILED_DOWNLOAD_NOTIFICATION @"IssueFailedDownload"

@interface Issue : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *downloadData;
    NSInteger expectedLength;
}

//issue ID
@property (nonatomic,copy)NSString *issueID;

//issue title
@property (nonatomic,copy)NSString *title;

//issue cover path
@property (nonatomic,copy)NSString *coverURL;

//issue download path
@property (nonatomic,copy)NSString *downloadURL;

//issue progress value
@property (nonatomic,readonly) float downloadProgress;

//issue download ID
@property(nonatomic,readonly,getter = isDownloading) BOOL downloading;

//issue download location
-(NSURL *)contentURL;

//issue image
-(UIImage *)coverImage;

//issue boolean read
-(BOOL)isIssueAvailibleForRead;

@end
