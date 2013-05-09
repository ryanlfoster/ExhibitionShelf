//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-28.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstCoverView.h"
@class Exhibition;
#define EXHIBITION_CHANGED_STATUS_NOTIFICATION @"ExhibitionChangedStatus"

typedef enum{
    ExhibitionStatusNotInizialized,
    ExhibitionStatusDownloading,
    ExhibitionStatusReady,
    ExhibitionStatusError
}ExhibitionStatusType;

@interface ExhibitionStore : NSObject<NSURLConnectionDataDelegate>{
    
    //store exhibition cover array
    NSMutableArray *exhibitionArray;
    
    //user exhibition downloaded
    NSMutableDictionary *userExhibition;
}

//Exhibition status 
@property (nonatomic,assign)ExhibitionStatusType status;

//NSOperationQueue easy better than NSOperationQueue bacause not extending or override
@property (nonatomic,retain)NSOperationQueue *downloadQueue;

//connect download NSOperation children NSInvocationOperation add to NSOperationQueue
@property (nonatomic,retain)NSInvocationOperation *op;

//init view
-(void)startup;

//Exhibition cover return boolean ready
-(BOOL)isExhibitionReady;

//retrive Exhibition downloaded if have set in userExhibition
-(void)loadInstalledExhibition;

//download exhibition
-(void)scheduleDownloadOfExhibition:(Exhibition *)exhibition;

//exhibition count
-(NSInteger)numberOfStoreExhibition;

//exhibition downloaded count
-(NSInteger)numberOfDownloadedExhibition;

//exhibitin location
-(Exhibition *)exhibitionAtIndex:(NSInteger)index;

//exhibition find depand on ID
-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID;

//clear queue
-(void)clearQueue:(Exhibition *)exhibition;

@end
