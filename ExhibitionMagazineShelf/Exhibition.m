//
//  Exhibition.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-3-29.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "Exhibition.h"
#import "ZipArchive.h"
#import "SqliteService.h"
#import "ShelfFirstViewController.h"
#import "ShelfThirdViewController.h"

static BOOL isDownloading;

@interface Exhibition()

@property (nonatomic, readonly) float downloadProgress;
@property (nonatomic, copy) NSMutableData *downloadData;
@property (nonatomic, assign) NSInteger expectedLength;
@property (nonatomic, retain) NSNumber *expectedLengthNumber;
@property (nonatomic, retain) NSNumber *downloadDataLengthNumber;
@property (nonatomic, strong) PlaySoundTools *sound;

-(void)alertDownloadErrorView;
-(void)sendConcealDownloadCoverImageViewNotification;
-(void)sendConcealPlayCoverImageViewNotification;
-(void)sendEndOfDownloadNotification;
-(void)sendFailedDownloadNotification;

@end

@implementation Exhibition
@synthesize date = _date;
@synthesize title = _title;
@synthesize sound = _sound;
@synthesize subTitle = _subTitle;
@synthesize coverURL = _coverURL;
@synthesize downloadURL = _downloadURL;
@synthesize description = _description;
@synthesize downloadData = _downloadData;
@synthesize exhibitionID = _exhibitionID;
@synthesize expectedLength = _expectedLength;
@synthesize downloadProgress = _downloadProgress;
@synthesize expectedLengthNumber = _expectedLengthNumber;
@synthesize downloadDataLengthNumber = _downloadDataLengthNumber;


#pragma mark -Class Methods
/**
 *	whether has exhibition is downloading
 *
 *	@return	BOOL
 */
+(BOOL)isDownlaoding
{
    return isDownloading;
}

#pragma mark -Public methods
/**
 *	CacheDirectory with wxhibitionID
 *
 *	@return	(NSURL *)CacheURL
 */
-(NSURL *)contentURL
{
    NSURL *CacheURL = [NSURL fileURLWithPath:[CacheDirectory stringByAppendingPathComponent:_exhibitionID]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[CacheURL path]]) {
        NSError *error=nil;
        if([[NSFileManager defaultManager] createDirectoryAtPath:[CacheURL path] withIntermediateDirectories:NO attributes:nil error:&error]==NO) {
            NSLog(@"There was an error in creating the directory: %@",error);
        }
        
    }
    return CacheURL;
}
/**
 *	cover image exhibition
 *
 *	@return	exhibition cover image path
 */
-(NSString *)exhibitionImagePath
{
    return[[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
}
/**
 *	file exhibition
 *
 *	@return	exhibition file path
 */
-(NSString *)exhibitionFilePath
{
    return [[[self contentURL] URLByAppendingPathComponent:@"exhibition"]path];
}
/**
 *	whether exhibition is ready for play
 *
 *	@return	BOOL 
 */
-(BOOL)isExhibitionAvailibleForPlay
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *contentPathDelete = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    if(contentPathDelete){
        [fileManger removeItemAtPath:contentPathDelete error:NULL];
    }
    
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition"] path];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:contentPath];
    NSLog(@"Checking for path: %@ ==> %d",contentPath,fileExists);
    return(fileExists);
}
/**
 *	stop downloading 
 */
-(void)stopDownload
{
    self.expectedLength = 0;
    isDownloading = NO;
    NSString *downloadURL = self.downloadURL;
    if(!downloadURL)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:self];
    [conn cancel];
}

#pragma mark -Override setter Methods
/**
 *	set download progress
 *
 *	@param	downloadProgress	transmit downloadProgress
 */
-(void)setDownloadProgress:(float)downloadProgress
{
    _downloadProgress = downloadProgress;
    NSLog(@"Download progress: %.0f%%",_downloadProgress * 100);
}

#pragma mark -NSURLConnectionDataDelegate
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called when enough data has been read to construct an NSURLResponse object. In the event of a protocol
 which may return multiple responses (such as HTTP multipart/x-mixed-replace) the delegate should be prepared to inspect the new response and make
 itself ready for data callbacks as appropriate.
 输入参数：(NSURLConnection *)connection :发送请求的对象  didReceiveResponse:(NSURLResponse *)response:接受到的回应
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(!_downloadData){
        _downloadData = [[NSMutableData alloc] init];
    }
    _expectedLength = [response expectedContentLength];
    NSLog(@"_expectedLength = %d",_expectedLength);
    
    if(_downloadData.length != 0){
        _downloadData.length = 0;
    }
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called with a single immutable NSData object to the delegate,representing the next portion of the data loaded
 from the connection.  This is the only guaranteed for the delegate to receive the data from the resource load.
 输入参数：(NSURLConnection *)connection :发送请求的对象  didReceiveData:(NSData *)data:接受到的数据
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(_expectedLength == 0){
        [connection cancel];
        _downloadData = nil;
        return;
    }
    
    isDownloading = YES;
    [_downloadData appendData:data];
    _expectedLengthNumber = [[NSNumber alloc]initWithInteger:_expectedLength];
    _downloadDataLengthNumber = [[NSNumber alloc] initWithInteger:[_downloadData length]];
    
    float expectedLengthFloat = [_expectedLengthNumber floatValue];
    float downloadDataLengthFloat = [_downloadDataLengthNumber floatValue];
    
    [self setDownloadProgress:downloadDataLengthFloat / expectedLengthFloat];
    
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called when all connection processing has completed successfully,before the delegate is released by the connection.
 输入参数：(NSURLConnection *)connection :发送请求的对象
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSURL *finalURL = [[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"];
        [_downloadData writeToURL:finalURL atomically:YES];
        
        NSString *zipPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"]path];
        ZipArchive *zip = [[ZipArchive alloc] init];
        if([zip UnzipOpenFile:zipPath]){
            BOOL ret = [zip UnzipFileTo:[self exhibitionFilePath] overWrite:YES];
            if(ret){
                NSLog(@"unzip success !!!");
                //send end of download notification
                //delete file
                NSFileManager *fileManger = [NSFileManager defaultManager];
                NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
                if([fileManger removeItemAtPath:contentPath error:NULL]){
                    [self addExhibitionInThirdView];
                }else return;
            }
            else{
                //delete incomplement UnzipFile
                [self alertDownloadErrorView];
            }
            [zip UnzipCloseFile];
        }
    });

}

-(void)addExhibitionInThirdView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShelfThirdViewController *stvc = [[ShelfThirdViewController alloc] init];
        [stvc addExhibition:self];
        isDownloading = NO;
    });
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：will be called at most once, if an error occurs during a resource load.  No other callbacks will be made after.
 输入参数：(NSURLConnection *)connection :发送请求的对象 didFailWithError:(NSError *)error
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    isDownloading = NO;
    NSLog(@"There was an error downloading this exhibition %@ with connection %@ . Error is: %@",self,connection,error);
    self.downloadProgress = 0.0;
    // post notification
    [self sendFailedDownloadNotification];
    return;
}

#pragma mark -Private Methods
/**
 *	alert download error view
 */
-(void)alertDownloadErrorView
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"呀吼！下载出错了请在再试一次!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alerView show];
    
    [self sendFailedDownloadNotification];
    
    //delete file
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    [fileManger removeItemAtPath:contentPath error:NULL];
    
}

#pragma mark -NSNotificationCenter
/**
 *	send conceal download cover image view notification
 */
-(void)sendConcealDownloadCoverImageViewNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:self];
}
/**
 *	send conceal play cover iamge view notification
 */
-(void)sendConcealPlayCoverImageViewNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CONCEAL_PLAYCOVERIMAGEVIEW_NOTIFICATION object:self];
}
/**
 *	send exhibition have finished notification
 */
-(void)sendEndOfDownloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:self];
}
/**
 *	send exhibition download failed notification
 */
-(void)sendFailedDownloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:self];
}
@end
