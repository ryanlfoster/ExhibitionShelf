//
//  SqliteService.h
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-5-6.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Exhibition.h"
@class Exhibition;
@interface SqliteService : NSObject

@property(nonatomic) sqlite3 *database;

-(void)createTable;//create db
-(void)insertToDB:(Exhibition *)exhibition;//insert data to db
-(BOOL)updateToDB:(Exhibition *)exhibition;//update db
-(void)deleteToDB:(NSString *)exhibitionID;//delete acorrding to id
-(NSUInteger)getCountToDB;

-(NSMutableArray *)getAllDateFromTable;//get all date 
@end

