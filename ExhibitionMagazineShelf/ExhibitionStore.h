//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-28.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstCoverView.h"

@class Exhibition;

typedef enum{
    ExhibitionStatusNotInizialized,
    ExhibitionStatusReady,
    ExhibitionStatusDownloading,
    ExhibitionStatusError
}ExhibitionStatusType;

@interface ExhibitionStore : NSObject

//store exhibition cover array
@property (nonatomic,retain) NSMutableArray * exhibitionArray;
//Exhibition status 
@property (nonatomic,assign) ExhibitionStatusType status;
//save list data
@property (nonatomic,retain) NSArray *list;

//init view
-(void)startup;
//download exhibition
-(void)scheduleDownloadOfExhibition:(Exhibition *)exhibition;
//clear queue
-(void)clearQueue:(Exhibition *)exhibition;
//Exhibition cover return boolean ready
-(BOOL)isExhibitionStoreReady;
//exhibition count
-(NSInteger)numberOfStoreExhibition;
//exhibitin location
-(Exhibition *)exhibitionAtIndex:(NSInteger)index;
//exhibition find depand on ID
-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID;

@end
