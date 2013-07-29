//
//  SqliteService.h
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-5-6.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <sqlite3.h>
#import "Exhibition.h"

@class Exhibition;

@interface SqliteService : NSObject

@property(nonatomic) sqlite3 *database;

-(void)createTable;
-(BOOL)insertToDB:(Exhibition *)exhibition;
-(BOOL)updateToDB:(Exhibition *)exhibition;
-(void)deleteToDB:(NSString *)exhibitionID;
-(NSUInteger)getCountToDB;
-(NSMutableArray *)getAllDateFromTable;

@end

