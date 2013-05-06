//
//  Exhibition.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "Exhibition.h"
#import "ZipArchive.h"
@interface Exhibition (Private){
    
}
-(void)sendEndOfDownloadNotification;
-(void)sendFailDownloadNotification;

@end

@implementation Exhibition
@synthesize exhibitionID = _exhibitionID;
@synthesize title = _title;
@synthesize coverURL = _coverURL;
@synthesize downloadURL = _downloadURL;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloading = _downloading;

@synthesize databasePath = _databasePath;

#pragma mark - Public methods
-(NSURL *)contentURL {
    NSURL *theURL = [NSURL fileURLWithPath:[CacheDirectory stringByAppendingPathComponent:_exhibitionID]];
    // create the URL
    if([[NSFileManager defaultManager] fileExistsAtPath:[theURL path]]==NO) {
        NSError *error=nil;
        if([[NSFileManager defaultManager] createDirectoryAtPath:[theURL path] withIntermediateDirectories:NO attributes:nil error:&error]==NO) {
            NSLog(@"There was an error in creating the directory: %@",error);
        }
        
    }
    return theURL;
}

-(UIImage *)coverImage
{
    // get imagePath
    NSString *imagePath = [[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    return theImage;
}

-(BOOL)isExhibitionAvailibleForRead
{
    // get contentPath
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:contentPath];
    NSLog(@"Checking for path: %@ ==> %d",contentPath,fileExists);
    return(fileExists);
    
}

-(BOOL)isDownloading
{
    return _downloading;
}

#pragma mark - Private methods
-(void)setDownloadProgress:(float)downloadProgress
{
    _downloadProgress = downloadProgress;
    NSLog(@"Download progress: %.0f%%",_downloadProgress * 100);
}

#pragma mark - NSURLDataConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(!downloadData){
        downloadData = [[NSMutableData alloc] init];
    }
    [downloadData setLength:0];
    
    //response expected content length
    expectedLength = [response expectedContentLength];
    NSLog(@"%d",expectedLength);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
    
    NSNumber *expectedLengthNumber = [[NSNumber alloc]initWithInteger:expectedLength];
    NSNumber *downloadDataLengthNumber = [[NSNumber alloc] initWithInteger:[downloadData length]];
    
    float expectedLengthFloat = [expectedLengthNumber floatValue];
    float downloadDataLengthFloat = [downloadDataLengthNumber floatValue];
    
    [self setDownloadProgress:downloadDataLengthFloat / expectedLengthFloat];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURL *finalURL = [[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"];
    [downloadData writeToURL:finalURL atomically:YES];
    
    NSString *zipPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"]path];
    NSString *documentPath = [[[self contentURL]URLByAppendingPathComponent:@"exhibition"]path];
    
/************************************************Zip operate********************************************************/    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:zipPath]){
        NSLog(@"open");
        BOOL ret = [zip UnzipFileTo:documentPath overWrite:YES];
        if(ret)NSLog(@"unzip success");
        else{
            //delete incomplement UnzipFile
            [self alertView];
        }


        [zip UnzipCloseFile];
    }
    
/************************************************DB operate********************************************************/
    NSString *docDir;//db path
    NSArray *pathsDir;//document directory
    pathsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = [pathsDir objectAtIndex:0];
    NSString *imagePath = [[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
    
    sqlite3_stmt *statement;
    _databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:@"exhibition.db"]];
    const char *dbpath = [_databasePath UTF8String];
    if(sqlite3_open(dbpath, &exhibitionDB)==SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO EXHIBITION(title,image,file) VALUES(\"%@\",\"%@\",\"%@\")",_title,imagePath,documentPath];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(exhibitionDB, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) {
            NSLog(@"has been saved to db !!!!!!");
            [self sendEndOfDownloadNotification];
        }else {
            NSLog(@"save to db fail !!!!!!!!");
            [self alertView];
        }
        sqlite3_finalize(statement);
        sqlite3_close(exhibitionDB);
        
    }
       
}
//Unzip \ save to db fail alertView
-(void)alertView
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"呀吼！下载出错了请在再试一次!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alerView show];
    
    //delete file
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    [fileManger removeItemAtPath:contentPath error:NULL];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"There was an error downloading this exhibition %@ with connection %@ . Error is: %@",self,connection,error);
    _downloading=NO;
    [self setDownloadProgress:0.0];
    // post notification
    [self sendFailedDownloadNotification];
}

#pragma mark - Notifications

-(void)sendEndOfDownloadNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:self];
}

-(void)sendFailedDownloadNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:self];
}


@end
