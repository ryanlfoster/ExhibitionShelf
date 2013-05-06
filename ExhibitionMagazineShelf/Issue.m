//
//  Issue.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-21.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "Issue.h"

@interface Issue()

-(void)sendEndOfDownloadNotification;
-(void)sendFailDownloadNotification;

@end

@implementation Issue
@synthesize title = _titile;
@synthesize issueID = _issueID;
@synthesize coverURL = _coverURL;
@synthesize downloadURL = _downloadURL;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloading = _downloading;

#pragma mark - Public methods
-(NSURL *)contentURL {
    NSURL *theURL = [NSURL fileURLWithPath:[CacheDirectory stringByAppendingPathComponent:_issueID]];
    // create theURl
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
    NSString *imagePath = [[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    return theImage;
}

-(BOOL)isIssueAvailibleForRead
{
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"magazine.pdf"] path];
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
    NSLog(@"Download progress: %.0f%%",_downloadProgress*100);
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(!downloadData){
        downloadData = [[NSMutableData alloc] init];
    }
    [downloadData setLength:0];
    
    //response expected length
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
    NSLog(@"End of download");
    NSURL *finalURL = [[self contentURL] URLByAppendingPathComponent:@"magazine.pdf"];
    [downloadData writeToURL:finalURL atomically:YES];
    [self sendEndOfDownloadNotification];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"There was an error downloading this issue %@ with connection %@ . Error is: %@",self,connection,error);
    _downloading=NO;
    
    [self setDownloadProgress:0.0];
    [self sendFailDownloadNotification];
}

#pragma mark - Notifications

-(void)sendEndOfDownloadNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_END_OF_DOWNLOAD_NOTIFICATION object:self];
}

-(void)sendFailDownloadNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_FAILED_DOWNLOAD_NOTIFICATION object:self];
}
@end
