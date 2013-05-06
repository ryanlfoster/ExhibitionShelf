//
//  Store.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-21.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Issue;
#define STORE_CHANGED_STATUS_NOTIFICATION @"StoreChangedStatus"

typedef enum{
    StoreStatusNotInizialized,
    StoreStatusDownloading,
    StoreStatusReady,
    StoreStatusError
}StoreStatusType;

@interface IssueStore : NSObject{
    
    //store issue
    NSMutableArray *IssueArray;
    
    //user dictionary
    NSMutableDictionary *userIssue;
    
    //downloadQueue
    NSOperationQueue *downloadQueue;
    
}

//store status 
@property (nonatomic,assign)StoreStatusType status;

//init
-(void)startup;

//boolean ready
-(BOOL)isStoreReady;

//download
-(void)scheduleDownloadOfIssue:(Issue *)issueToDownload;

//issueStore count
-(NSInteger)numberOfStoreIssues;

//issue location
-(Issue *)issueAtIndex:(NSInteger)index;

//find issue with ID
-(Issue *)issueWithID:(NSString *)issueID;
@end
