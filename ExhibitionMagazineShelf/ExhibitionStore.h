//
//  Exhibition.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-28.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

@class Exhibition;

typedef enum{
    
    ExhibitionStatusNotInizialized,
    ExhibitionStatusReady,
    ExhibitionStatusDownloading,
    ExhibitionStatusError
    
}ExhibitionStatusType;

@interface ExhibitionStore : NSObject

@property (nonatomic,retain) NSMutableArray * exhibitionArray;
@property (nonatomic,assign) ExhibitionStatusType status;
@property (nonatomic,retain) NSArray *list;

-(void)startup;
-(BOOL)isExhibitionStoreReady;
-(NSInteger)numberOfStoreExhibition;
-(Exhibition *)exhibitionAtIndex:(NSInteger)index;
-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID;

@end
