//
//  SqliteService.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-5-6.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "SqliteService.h"

@implementation SqliteService
@synthesize database = _database;

/**
 *	return data file path
 *
 *	@return	data file path 
 */
-(NSString *)dataFilePath
{
    return [DocumentsDirectory stringByAppendingPathComponent:@"exhibition.db"];
}

/**
 *	open db
 *
 *	@return	TRUE:exist or FALSE:none
 */
-(BOOL)openDB
{
    //get db path
    NSString *path = [self dataFilePath];
    //file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //judge db exist
    BOOL find = [fileManager fileExistsAtPath:path];
    //if return true, open sqlite
    if(find){
        if(sqlite3_open([path UTF8String],&_database) !=SQLITE_OK){
            //if fail to open db , so shut down db
            sqlite3_close(_database);
            NSLog(@"Error: open database file.");
			return NO;
        }
        //create new table
        [self createTable];
        return YES;
    }
    
    //if db no exist,use sqlite3_open create db
    if(sqlite3_open([path UTF8String], &_database) == SQLITE_OK){
        //create table
        [self createTable];
        return YES;
    }else{
        //if fail to open db , so shut down db
        sqlite3_close(_database);
        NSLog(@"Error: open database file.");
        return NO;
    }
    return NO;
}

/**
 *	create table
 */
-(void)createTable
{
    sqlite3_stmt *statement;
    const char *sql_stmt = "CREATE TABLE IF NOT EXISTS EXHIBITION(ID INTEGER PRIMARY KEY AUTOINCREMENT,EXHIBITIONID TEXT,TITLE TEXT,SUBTITLE TEXT,DATE TEXT,DOWNLOAD TEXT)";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database,sql_stmt,-1,&statement,nil);
    
    //if sql sentense analysis error return
    if(sqlReturn != SQLITE_OK){
        NSLog(@"Error:failerd to sql sentense analysis!!!");
    }
    //execute sql sentense
    int success = sqlite3_step(statement);
    //release sqlite3_stmt
    sqlite3_finalize(statement);
    //if execute sentense error return
    if(success != SQLITE_DONE){
        NSLog(@"Error:failed to execute sentense !!!");
    }
    
}

/**
 *	insert exhibition to table
 *
 *	@param	exhibition	exhibition which ready for inserting
 *
 *	@return	YES:success NO:Error
 */
-(BOOL)insertToDB:(Exhibition *)exhibition
{
    
    if([self openDB]){
        
        sqlite3_stmt *statement;
        
        //insert exhibition to sql
        const char *insert_stmt = "INSERT INTO EXHIBITION(exhibitionid,title,subtitle,date,download) values(?,?,?,?,?)";
        int success = sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL);
        
        if (success != SQLITE_OK) {
            NSLog(@"Error:failed to insert");
            sqlite3_close(_database);
            return false;
        }

        //execute insert operate
        sqlite3_bind_text(statement, 1, [exhibition.exhibitionID UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [exhibition.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [exhibition.subTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [exhibition.date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [exhibition.downloadURL UTF8String], -1, SQLITE_TRANSIENT);
        
        //execute insert sentense
        success = sqlite3_step(statement);
        //release statement
        sqlite3_finalize(statement);

        //if insert fail
        if(success == SQLITE_ERROR){
            NSLog(@"Error : failed to insert into the database !!!");
            return false;
            sqlite3_close(_database);
        }else{
            return true;
            sqlite3_close(_database);
        }
    }
    return false;
}

/**
 *	update table
 *
 *	@param	exhibition	exhibition
 *
 *	@return	YES:success NO:error
 */
-(BOOL)updateToDB:(Exhibition *)exhibition
{
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *update_stmt = "UPDATE EXHIBITION set exhibitionid = ?,title = ?,subtitle = ?,date = ?,download = ?";
        int success = sqlite3_prepare_v2(_database, update_stmt, -1, &statement, NULL);
        if(success != SQLITE_OK){
            NSLog(@"Error: failed to update !!!!");
            sqlite3_close(_database);
        }
        sqlite3_bind_text(statement, 1, [exhibition.exhibitionID UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [exhibition.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [exhibition.subTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [exhibition.date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [exhibition.downloadURL UTF8String], -1, SQLITE_TRANSIENT);
        
        //execute sql sentense , update db
        success = sqlite3_step(statement);
        //release statement
        sqlite3_finalize(statement);
        
        //if update fail
        if (success == SQLITE_ERROR) {
            NSLog(@"Error:failed to update the database");
            //close db
            sqlite3_close(_database);
        }
        //after execute , still close db
        sqlite3_close(_database);
        return YES;
        
    }
    return NO;
}

/**
 *	delete exhibition in table
 *
 *	@param	exhibitionID	with exhibition id 
 */
-(void)deleteToDB:(NSString *)exhibitionID
{
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *delete_stmt = "DELETE from EXHIBITION where EXHIBITIONID = ? ";
        
        int success = sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL);
        if(success != SQLITE_OK){
            NSLog(@"Error: failed to delete");
			sqlite3_close(_database);
        }
        NSLog(@"%@",exhibitionID);
        sqlite3_bind_text(statement, 1, [exhibitionID UTF8String], -1, SQLITE_TRANSIENT);
            
        //execute sql sentense,update db
        success = sqlite3_step(statement);
        //release db
        sqlite3_finalize(statement);
        
        //if delete fail
        if(success == SQLITE_ERROR){
            NSLog(@"Error:failed to delete the database");
            //close db
            sqlite3_close(_database);
        }
        //after execute successful,still close db
        sqlite3_close(_database);
        
    }
}

/**
 *	get all data from table
 *
 *	@return	array exhibition
 */
-(NSMutableArray *)getAllDateFromTable
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //first judge db open
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *get_statement = "SELECT EXHIBITIONID,TITLE,SUBTITLE,DATE,DOWNLOAD FROM EXHIBITION";
        
        if(sqlite3_prepare_v2(_database, get_statement, -1, &statement, NULL) != SQLITE_OK){
            NSLog(@"Error: failed to get date");
        }else{
            //enumaration all 
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Exhibition *exhibition  = [[Exhibition alloc]init];
                exhibition.exhibitionID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                exhibition.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                exhibition.subTitle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                exhibition.date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                exhibition.downloadURL = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                [array addObject:exhibition];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return array;
}

/**
 *	exhibition count in table
 *
 *	@return	count
 */
-(NSUInteger)getCountToDB
{
    
    NSUInteger count = 0;
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *getCount_statement = "SELECT COUNT(*) FROM EXHIBITION";
        if(sqlite3_prepare_v2(_database, getCount_statement,-1,&statement,NULL) != SQLITE_OK)
        {
            NSLog(@"Error: failed to get date");
        }else{
            while (sqlite3_step(statement) == SQLITE_ROW) {
                count++;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return count;
}

@end

