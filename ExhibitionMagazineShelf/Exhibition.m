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
@synthesize downloadData = _downloadData;
@synthesize expectedLength = _expectedLength;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloading = _downloading;

@synthesize image = _image;
@synthesize file = _file;

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

-(NSString *)exhibitionImagePath
{
    // get image cover path
    return[[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
}

-(NSString *)exhibitionFilePath{
    //get exhibition dir path
    return [[[self contentURL] URLByAppendingPathComponent:@"exhibition"]path];
}

-(BOOL)isExhibitionAvailibleForRead
{
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
    if(!_downloadData){
        _downloadData = [[NSMutableData alloc] init];
    }
    [_downloadData setLength:0];
    
    //response expected content length
    _expectedLength = [response expectedContentLength];
    NSLog(@"%d",_expectedLength);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
    
    NSNumber *expectedLengthNumber = [[NSNumber alloc]initWithInteger:_expectedLength];
    NSNumber *downloadDataLengthNumber = [[NSNumber alloc] initWithInteger:[_downloadData length]];
    
    float expectedLengthFloat = [expectedLengthNumber floatValue];
    float downloadDataLengthFloat = [downloadDataLengthNumber floatValue];
    
    [self setDownloadProgress:downloadDataLengthFloat / expectedLengthFloat];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSURL *finalURL = [[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"];
    [_downloadData writeToURL:finalURL atomically:YES];
    
    NSString *zipPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"]path];
    
/**************************************Zip operate*******************************************/    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:zipPath]){
        NSLog(@"open");
        BOOL ret = [zip UnzipFileTo:[self exhibitionFilePath] overWrite:YES];
        if(ret){
            NSLog(@"unzip success");
            
            //init SqlService
            SqliteService *sqlService = [[SqliteService alloc] init];
            //packaging exhibition
            _image = [self exhibitionImagePath];
            _file = [self exhibitionFilePath];
            [sqlService insertToDB:self];
            //send end of download notification
            [self sendEndOfDownloadNotification];
        }
        else{
            //delete incomplement UnzipFile
            [self alertView];
        }
        
        [zip UnzipCloseFile];
    }
       
}
//fail alertView
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
