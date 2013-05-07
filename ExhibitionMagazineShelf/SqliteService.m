//
//  SqliteService.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-5-6.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "SqliteService.h"
#import "Exhibition.h"
@implementation SqliteService
//-(void)getAllToDB;
@synthesize database = _database;
-(id)init
{
    return self;
}

//get document path
-(NSString *)dataFilePath
{
    return [DocumentsDirectory stringByAppendingPathComponent:@"exhibition.db"];
}
//create;open db
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
        NSLog(@"Database file have already existed.");
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

//create table
-(void)createTable
{
    sqlite3_stmt *statement;
    const char *sql_stmt = "CREATE TABLE IF NOT EXISTS EXHIBITION(ID INTEGER PRIMARY KEY AUTOINCREMENT,TITLE TEXT,IMAGE TEXT,FILE TEXT)";
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

//insert data
-(void)insertToDB:(Exhibition *)exhibition
{
    
    if([self openDB]){
        
        sqlite3_stmt *statement;
        const char *insert_stmt = "INSERT INTO EXHIBITION(title,image,file) values(?,?,?)";
        int success = sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL);
        
        if (success != SQLITE_OK) {
            NSLog(@"Error:failed to insert");
            sqlite3_close(_database);
        }
        
        //execute insert operate
        sqlite3_bind_text(statement, 1, [exhibition.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[exhibition exhibitionImagePath] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[exhibition exhibitionFilePath] UTF8String], -1, SQLITE_TRANSIENT);
        
        //execute insert sentense
        success = sqlite3_step(statement);
        //release statement
        sqlite3_finalize(statement);

        //if insert fail
        if(success == SQLITE_ERROR){
            NSLog(@"Error : failed to insert into the database !!!");
            //close db
            sqlite3_close(_database);
        }
        //close db
        sqlite3_close(_database);
        
    }
}

//update db
-(BOOL)updateToDB:(Exhibition *)exhibition
{
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *update_stmt = "UPDATE EXHIBITION set title = ?,image = ?,path = ?";
        int success = sqlite3_prepare_v2(_database, update_stmt, -1, &statement, NULL);
        if(success != SQLITE_OK){
            NSLog(@"Error: failed to update !!!!");
            sqlite3_close(_database);
        }
        
        sqlite3_bind_text(statement, 1, [exhibition.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[exhibition exhibitionImagePath] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[exhibition exhibitionFilePath] UTF8String], -1, SQLITE_TRANSIENT);
        
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
//delete data
-(BOOL)deleteToDB:(Exhibition *)exhibition
{
    if([self openDB]){
        
        sqlite3_stmt *statement;
        const char *delete_stmt = "DELETE from EXHIBITION where title = ?";
        
        int success = sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL);
        if(success != SQLITE_OK){
            NSLog(@"Error: failed to delete:testTable");
			sqlite3_close(_database);
			return NO;
        }
        
        sqlite3_bind_text(statement, 1, [exhibition.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[exhibition exhibitionImagePath] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[exhibition exhibitionFilePath] UTF8String], -1, SQLITE_TRANSIENT);
            

        //execute sql sentense,update db
        success = sqlite3_step(statement);
        //release db
        sqlite3_finalize(statement);
        
        //if delete fail
        if(success == SQLITE_ERROR){
            NSLog(@"Error:failed to delete the database");
            //close db
            sqlite3_close(_database);
            return NO;
        }
        //after execute successful,still close db
        sqlite3_close(_database);
        return YES;
        
    }
    return NO;
}

//get all data from table
-(NSMutableArray *)getAllDateFromTable
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //first judge db open
    if([self openDB]){
        sqlite3_stmt *statement;
        const char *get_statement = "SELECT TITLE,IMAGE,FILE FROM EXHIBITION";
        
        if(sqlite3_prepare_v2(_database, get_statement, -1, &statement, NULL) != SQLITE_OK){
            NSLog(@"Error: failed to get date");
        }else{
            //enumaration all 
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Exhibition *exhibition  = [[Exhibition alloc]init];
                exhibition.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                exhibition.image = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                exhibition.file = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                [array addObject:exhibition];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
    return array;
}
@end

